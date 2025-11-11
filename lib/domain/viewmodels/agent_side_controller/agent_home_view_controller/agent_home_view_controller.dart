
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_favourite_view_controller/agent_favourite_view_controller.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import '../../../../core/enum/enum.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
import '../../../../data/repositories/agent_side_repository/agent_side_home_repo.dart';
import '../../../../data/repositories/swiperep.dart';
import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../model/user_model/user_model.dart';

class AgentHomeViewController extends GetxController {
  final AgentFavouriteViewController favouriteController = Get.find();
  final UserProfileRepository _repository = UserProfileRepository();
  final AgentSideHomeRepo repo = AgentSideHomeRepo();
  final CardSwiperController swiperController = CardSwiperController();
  final SwipesRepository sr=SwipesRepository();

  final RxList<UserModel> currentCards = <UserModel>[].obs;
  final RxSet<String> likedNames = <String>{}.obs;

  final RxInt currentIndex = 0.obs;
  final RxDouble progress = 0.0.obs;
  final RxBool isLoading = true.obs;
  final RxBool showRefresh = false.obs;

  late Timer _progressTimer;

  var swipeAction = SwipeAction.none.obs;
  var swipedCardName = ''.obs;
  var swipePreviewDirection = SwipeAction.none.obs;
  var swipePreviewCardName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    startProgressTimer();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final users = await _repository.fetchAllUsersForCards();
      if (users.isNotEmpty) {
        currentCards.assignAll(users..shuffle());
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
      startProgressTimer();
    }
  }

  void resetProgress() {
    progress.value = 0.0;
  }

  void startProgressTimer() {
    resetProgress();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (progress.value >= 1.0) {
        timer.cancel();
      } else {
        progress.value += 0.01;
      }
    });
  }

  void autoSwipeLeft() {
    if (currentIndex.value < currentCards.length - 1) {
      swiperController.swipe(CardSwiperDirection.left);
      currentIndex.value++;
      startProgressTimer();
    }
  }

  @override
  Future<bool> onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) async {
    _progressTimer.cancel();

    final swipedUser = currentCards[previousIndex];
    final agentId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final userId = swipedUser.userId ?? "";
    if (direction == CardSwiperDirection.right) {
      likedNames.add(swipedUser.displayName ?? '');
      swipeAction.value = SwipeAction.like;

      // Record swipe in shared swipes collection
      sr.recordSwipe(swiperId: agentId, targetId: userId);

      // Save to favourites
      await FirebaseFirestore.instance
          .collection('users')
          .doc(agentId)
          .collection('favourites')
          .doc(userId)
          .set({
        'addedAt': FieldValue.serverTimestamp(),
        'name': swipedUser.displayName,
        'email': swipedUser.email,
        'location': swipedUser.location,
      });

      showSnackBar(swipedUser.email ?? "User", action: "like");
    }

    else if (direction == CardSwiperDirection.left) {
      swipeAction.value = SwipeAction.dislike;

      // AgentProfileRepository().recordSwipe(
      //   agentUserId: agentId,
      //   currentUserId: userId,
      //   liked: false,
      // );
      sr.recordSwipe(swiperId: agentId, targetId: userId);


      // ✅ Remove from favourites
      FirebaseFirestore.instance
          .collection('users')
          .doc(agentId)
          .collection('favourites')
          .doc(userId)
          .delete();

      showSnackBar(swipedUser.email ?? "User", action: "dislike");
    }

    if ((currentIndex ?? previousIndex) >= currentCards.length - 1) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        showRefresh.value = false;
        await fetchUsers();
        startProgressTimer();
      });
    }

    return true;
  }

  Future<void> handleLikeSwipeForAgent(
      String agentId, String userId, UserModel swipedUser) async {
    try {
      final userFav = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favourites')
          .doc(agentId)
          .get();

      if (userFav.exists) {
        // ✅ Both liked → It's a match
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .add({
          'fromUserId': agentId,
          'fromUserEmail': FirebaseAuth.instance.currentUser?.email,
          'type': 'match',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(agentId)
            .collection('notifications')
            .add({
          'fromUserId': userId,
          'fromUserEmail': swipedUser.email,
          'type': 'match',
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("🎉 Match created for $agentId and $userId");
      } else {
        // ✅ Only like notification
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .add({
          'fromUserId': agentId,
          'fromUserEmail': FirebaseAuth.instance.currentUser?.email,
          'type': 'like',
          'createdAt': FieldValue.serverTimestamp(),
        });

        print("👍 Like notification created for $userId");
      }
    } catch (e) {
      print("🔥 Error in handleLikeSwipeForAgent: $e");
    }
  }



  void showSnackBar(String email, {required String action}) {
    Color bgColor;
    IconData icon;
    String message;

    if (action == "like") {
      bgColor = AppColors.primary;
      icon = Icons.favorite;
      message = "You liked $email";
    } else if (action == "dislike") {
      bgColor = Colors.red;
      icon = Icons.close;
      message = "You disliked $email";
    } else {
      bgColor = Colors.blue;
      icon = Icons.star;
      message = "$email has been added to favourites 💙";
    }

    Get.showSnackbar(
      GetSnackBar(
        message: message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(seconds: 1),
        backgroundColor: bgColor,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  void onClose() {
    _progressTimer.cancel();
    super.onClose();
  }
}
