import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_favourite_view_controller/agent_favourite_view_controller.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import '../../../../core/enum/enum.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
import '../../../../data/repositories/agent_side_repository/agent_side_home_repo.dart';
import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../model/user_model/user_model.dart';


class AgentHomeViewController extends GetxController {
  final AgentFavouriteViewController favouriteController = Get.find();
  final UserProfileRepository _repository = UserProfileRepository();
  final AgentSideHomeRepo repo = AgentSideHomeRepo();
  final CardSwiperController swiperController = CardSwiperController();

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
      final users = await _repository.fetchAllUsersForCards(); // now returns List<UserModel>
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
        // autoSwipeLeft(); // if you want auto swipe
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
  //
  // @override
  // bool onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
  //   _progressTimer.cancel();
  //
  //   final swipedUser = currentCards[previousIndex];
  //   this.currentIndex.value = currentIndex ?? previousIndex;
  //   swipedCardName.value = swipedUser.name ?? "Unknown";
  //
  //   if (direction == CardSwiperDirection.right) {
  //     likedNames.add(swipedUser.name ?? "");
  //     swipeAction.value = SwipeAction.like;
  //
  //     // favouriteController.addToFavourites(swipedUser);
  //
  //     showSnackBar(swipedUser.name ?? "User", action: "like");
  //   } else if (direction == CardSwiperDirection.left) {
  //     swipeAction.value = SwipeAction.dislike;
  //     showSnackBar(swipedUser.name ?? "User", action: "dislike");
  //   }
  //
  //   Future.delayed(const Duration(milliseconds: 400), () {
  //     swipeAction.value = SwipeAction.none;
  //     swipedCardName.value = '';
  //   });
  //
  //   if (this.currentIndex.value >= currentCards.length) {
  //     showRefresh.value = true;
  //     return true;
  //   }
  //
  //   startProgressTimer();
  //   return true;
  // }
  //
  // void updateSwipePreview(double percentX, String cardName) {
  //   if (percentX >= 0.2) {
  //     swipePreviewDirection.value = SwipeAction.like;
  //     swipePreviewCardName.value = cardName;
  //   } else if (percentX <= -0.2) {
  //     swipePreviewDirection.value = SwipeAction.dislike;
  //     swipePreviewCardName.value = cardName;
  //   } else {
  //     swipePreviewDirection.value = SwipeAction.none;
  //     swipePreviewCardName.value = '';
  //   }
  // }

  bool onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    _progressTimer.cancel();

    final swipedUser = currentCards[previousIndex];
    final agentId = FirebaseAuth.instance.currentUser?.uid ?? "";
    final userId = swipedUser.userId ?? "";

    if (direction == CardSwiperDirection.right) {
      likedNames.add(swipedUser.email ?? "");
      swipeAction.value = SwipeAction.like;

      repo.addFavourite(agentId, userId);

      // Record swipe
      AgentProfileRepository().recordSwipe(
        agentUserId: agentId,
        currentUserId: userId,
        liked: true,
      );

      repo.firebaseService.checkMatch(agentId, userId).then((isMatch) {
        if (isMatch) {
          repo.firebaseService.saveMatch(agentId, userId);
          // Optional: Navigate to chat or show match popup
          // Get.toNamed(AppRoutes.chat, arguments: {"agentId": agentId, "userId": userId});
        }
      });

      showSnackBar(swipedUser.email ?? "Unknown", action: "like");
    } else if (direction == CardSwiperDirection.left) {
      swipeAction.value = SwipeAction.dislike;

      AgentProfileRepository().recordSwipe(
        agentUserId: agentId,
        currentUserId: userId,
        liked: false,
      );

      showSnackBar(swipedUser.email ?? "Unknown", action: "dislike");
    }

    return true;
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
