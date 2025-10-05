// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:get/get.dart';
// import 'package:propmeet/model/agent_model/agent_model.dart';
// import 'package:propmeet/shared/config/app_assets/app_assets.dart';
//
// import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
// import '../../../../data/repositories/user_side_repository/user_side_home_repo.dart';
// import '../../../../presentation/views/user_side_views/home_view/home_custom_widgets/card_items.dart';
// import '../favourites_view_controller/favourite_view_controller.dart';
//
// class HomeController extends GetxController {
//  late FavouriteViewController favouriteController;
//   //
//   //final FavouriteViewController favouriteController = Get.find();
//   //
//    final CardSwiperController swiperController = CardSwiperController();
//   final RxInt currentIndex = 0.obs;
//   final RxDouble progress = 0.0.obs;
//
//
//   late Timer _progressTimer;
//
//   final List<Map<String, String>> allUsers = [
//     {'name': 'Ahmad', 'image': AppAssets.user1, 'distance': '13'},
//     {'name': 'Ali', 'image':  AppAssets.user2,'distance': '2'},
//     {'name': 'Charlie', 'image':  AppAssets.user3,'distance': '130'},
//     {'name': 'Ping', 'image':  AppAssets.user4,'distance': '120'},
//     {'name': 'Ahmad', 'image': AppAssets.user1,'distance': '22'},
//     {'name': 'Ali', 'image':  AppAssets.user2,'distance': '11'},
//     {'name': 'Charlie', 'image':  AppAssets.user3,'distance': '13'},
//     {'name': 'Ping', 'image':  AppAssets.user4,'distance': '223'},
//   ];
//
//   final RxList<Map<String, String>> currentCards = <Map<String, String>>[].obs;
//   final RxSet<String> likedNames = <String>{}.obs;
//
//   final RxBool isLoading = true.obs;
//
//   final RxBool showRefresh = false.obs;
//
//   HomeController() {
//     currentCards.value = List<Map<String, String>>.from(allUsers)..shuffle();
//   }
//
//   var likeAnimationTrigger = false.obs; // this will trigger my heart wala icon
//   var dislikeAnimationTrigger = false.obs;
//   var swipeAction = SwipeAction.none.obs;
//
//   var swipedCardName = ''.obs;
//
//   var swipePreviewDirection = SwipeAction.none.obs;
//   var swipePreviewCardName = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     favouriteController = Get.find<FavouriteViewController>();
//     Future.delayed(const Duration(seconds: 5), () {
//       isLoading.value = false;
//     });
//
//     startProgressTimer();
//   }
//
//   void shuffleUsers() {
//     currentCards.value = List<Map<String, String>>.from(allUsers)..shuffle();
//     currentIndex.value = 0;
//     resetProgress();
//     startProgressTimer();
//     showRefresh.value = false;
//   }
//
//   void resetProgress() {
//     progress.value = 0.0;
//   }
//
//   void startProgressTimer() {
//     resetProgress();
//     _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (progress.value >= 1.0) {
//         timer.cancel();
//     //    autoSwipeLeft();
//       } else {
//         progress.value += 0.01;
//       }
//     });
//   }
//
//   void autoSwipeLeft() {
//     if (currentIndex.value < currentCards.length - 1) {
//       swiperController.swipe(CardSwiperDirection.left);
//       currentIndex.value++;
//       startProgressTimer();
//     }
//   }
//
//
//   @override
//   bool onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
//     _progressTimer.cancel();
//
//     final swipedUser = currentCards[previousIndex];
//     this.currentIndex.value = currentIndex ?? previousIndex;
//     swipedCardName.value = swipedUser['name']!;
//
//     if (direction == CardSwiperDirection.right) {
//       likedNames.add(swipedUser['name']!);
//       swipeAction.value = SwipeAction.like;
//
//       favouriteController.addToFavourites(swipedUser);
//
//       showSnackBar(swipedUser['name']!, action: "like");
//     } else if (direction == CardSwiperDirection.left) {
//       swipeAction.value = SwipeAction.dislike;
//       showSnackBar(swipedUser['name']!, action: "dislike");
//     }
//
//     Future.delayed(const Duration(milliseconds: 400), () {
//       swipeAction.value = SwipeAction.none;
//       swipedCardName.value = '';
//     });
//
//     if (this.currentIndex.value >= currentCards.length) {
//       showRefresh.value = true;
//       return true;
//     }
//
//     startProgressTimer();
//     return true;
//   }
//
//
//   void updateSwipePreview(double percentX, String cardName) {
//     if (percentX >= 0.2) {
//       swipePreviewDirection.value = SwipeAction.like;
//       swipePreviewCardName.value = cardName;
//     } else if (percentX <= -0.2) {
//       swipePreviewDirection.value = SwipeAction.dislike;
//       swipePreviewCardName.value = cardName;
//     } else {
//       swipePreviewDirection.value = SwipeAction.none;
//       swipePreviewCardName.value = '';
//     }
//   }
//
//
//   void showSnackBar(String name, {required String action}) {
//     Color bgColor;
//     IconData icon;
//     String message;
//
//     if (action == "like") {
//       bgColor = Colors.green;
//       icon = Icons.favorite;
//       message = "You liked $name";
//     } else if (action == "dislike") {
//       bgColor = Colors.red;
//       icon = Icons.close;
//       message = "You disliked $name";
//     } else { // favourite
//       bgColor = Colors.blue;
//       icon = Icons.star;
//       message = "$name has been added to favourites 💙";
//     }
//
//     Get.showSnackbar(
//       GetSnackBar(
//         message: message,
//         snackPosition: SnackPosition.BOTTOM,
//         margin: const EdgeInsets.all(12),
//         borderRadius: 8,
//         duration: const Duration(seconds: 2),
//         backgroundColor: bgColor,
//         icon: Icon(icon, color: Colors.white),
//       ),
//     );
//   }
//
//
//   @override
//   void onClose() {
//     _progressTimer.cancel();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/model/agent_model/agent_model.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import '../../../../data/repositories/agent_side_repository/agent_profile_repo.dart';
import '../../../../data/repositories/swipes_repository/swipes_repository.dart';
import '../../../../data/repositories/user_side_repository/user_profile_repo.dart';
import '../../../../presentation/views/user_side_views/home_view/home_custom_widgets/card_items.dart';
import '../favourites_view_controller/favourite_view_controller.dart';


class HomeController extends GetxController {
  late FavouriteViewController favouriteController;
  final AgentProfileRepository _agentRepo = AgentProfileRepository();
  final UserProfileRepository userRepo = UserProfileRepository();
  final CardSwiperController swiperController = CardSwiperController();
  final RxInt currentIndex = 0.obs;
  final RxDouble progress = 0.0.obs;

  Timer? _progressTimer;

  // keep a raw list for reference if needed
  final List<AgentFieldData> allAgentObjects = [];

  final RxList<Map<String, String>> currentCards = <Map<String, String>>[].obs;
  final RxSet<String> likedNames = <String>{}.obs;

  final RxBool isLoading = true.obs;
  final RxBool showRefresh = false.obs;

  HomeController() {
    // leave constructor small — real load happens in onInit
  }

  var likeAnimationTrigger = false.obs;
  var dislikeAnimationTrigger = false.obs;
  var swipeAction = SwipeAction.none.obs;

  var swipedCardName = ''.obs;

  var swipePreviewDirection = SwipeAction.none.obs;
  var swipePreviewCardName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    favouriteController = Get.find<FavouriteViewController>();
    _loadAgents();
    startProgressTimer();
  }

  // file: domain/viewmodels/user_side_controller/home_controller/home_controller.dart
  Future<void> _loadAgents() async {
    try {
      isLoading.value = true;

      // NOTE: fetchAllAgents now returns List<Map<String,dynamic>> where each item has id and agent
      final agentEntries = await _agentRepo.fetchAllAgents();

      allAgentObjects.clear();
      // Build card list with id, so we can send writes back
      final cards = agentEntries.map((entry) {
        final id = entry['id'] as String;
        final a = entry['agent'] as AgentFieldData;
        allAgentObjects.add(a);
        final displayName = "${a.firstName.isNotEmpty ? a.firstName : ''}"
            "${a.lastName.isNotEmpty ? ' ${a.lastName}' : ''}"
            .trim();
        final image = (a.profileImage.isNotEmpty) ? a.profileImage : AppAssets.user1;
        final distance = (a.medianDaysOnMarket.isNotEmpty) ? "${a.medianDaysOnMarket} " : "5 km";

        return {
          'id': id,
          'name': displayName.isNotEmpty ? displayName : (a.phoneNumber.isNotEmpty ? a.phoneNumber : 'Agent'),
          'image': image,
          'distance': distance,
        };
      }).toList();

      cards.shuffle();
      currentCards.value = List<Map<String, String>>.from(cards);

      Future.delayed(const Duration(milliseconds: 200), () {
        isLoading.value = false;
      });
    } catch (e, st) {
      print("Error loading agents: $e\n$st");
      isLoading.value = false;
      Get.showSnackbar(
        GetSnackBar(
          message: "Failed to load agents",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  void shuffleUsers() {
    currentCards.shuffle();
    currentIndex.value = 0;
    resetProgress();
    startProgressTimer();
    showRefresh.value = false;
  }

  void resetProgress() {
    progress.value = 0.0;
  }

  void startProgressTimer() {
    resetProgress();
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (progress.value >= 1.0) {
        timer.cancel();
        // autoSwipeLeft(); // optional
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
  bool onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    _progressTimer?.cancel();

    if (previousIndex < 0 || previousIndex >= currentCards.length) {
      return true;
    }

    final swipedUser = currentCards[previousIndex];
    this.currentIndex.value = currentIndex ?? previousIndex;
    swipedCardName.value = swipedUser['name'] ?? '';

    final agentId = swipedUser['id'] ?? '';
    if (agentId.isEmpty) {
      print('Skipping swipe — missing agentId for user: ${swipedUser['name']}');
      return true;
    }

    final SwipeRepository swipeRepo = SwipeRepository();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (direction == CardSwiperDirection.right) {

      likedNames.add(swipedUser['name'] ?? '');
      swipeAction.value = SwipeAction.like;
      handleLikeSwipe(currentUserId ?? "", agentId, swipedUser)
          .catchError((e) => print("handleLikeSwipe error: $e"));

      // Record swipe in swipe collection (your existing logic)
      swipeRepo.recordSwipe(
        targetId: agentId,
        liked: true,
        currentUserType: UserType.user,
        targetType: UserType.agent,
      ).catchError((e) => print('recordSwipe like error: $e'));

      // ✅ NEW: Add to favourites collection in Firestore
      if (currentUserId != null && currentUserId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('favourites')
            .doc(agentId)
            .set({
          'addedAt': FieldValue.serverTimestamp(),
          'name': swipedUser['name'],
          'image': swipedUser['image'],
          'distance': swipedUser['distance'],
        })
            .then((_) => print('❤️ Added ${swipedUser['name']} to favourites'))
            .catchError((e) => print('🔥 Error adding favourite: $e'));
      }

      // Optionally: update local FavouriteViewController immediately (no delay)
      favouriteController.fetchFavouriteAgents();

      showSnackBar(swipedUser['name'] ?? '', action: "like");
    } else if (direction == CardSwiperDirection.left) {
      swipeAction.value = SwipeAction.dislike;

      swipeRepo.recordSwipe(
        targetId: agentId,
        liked: false,
        currentUserType: UserType.user,
        targetType: UserType.agent,
      ).catchError((e) => print('recordSwipe dislike error: $e'));

      if (currentUserId != null && currentUserId.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('favourites')
            .doc(agentId)
            .delete()
            .then((_) =>
            print('💔 Removed ${swipedUser['name']} from favourites'))
            .catchError((e) => print('🔥 Error removing favourite: $e'));
      }

      // Optionally refresh local list immediately
      favouriteController.fetchFavouriteAgents();

      showSnackBar(swipedUser['name'] ?? '', action: "dislike");
    }
    return true;
  }



  void updateSwipePreview(double percentX, String cardName) {
    if (percentX >= 0.2) {
      swipePreviewDirection.value = SwipeAction.like;
      swipePreviewCardName.value = cardName;
    } else if (percentX <= -0.2) {
      swipePreviewDirection.value = SwipeAction.dislike;
      swipePreviewCardName.value = cardName;
    } else {
      swipePreviewDirection.value = SwipeAction.none;
      swipePreviewCardName.value = '';
    }
  }

  void showSnackBar(String name, {required String action}) {
    Color bgColor;
    IconData icon;
    String message;

    if (action == "like") {
      bgColor = Colors.green;
      icon = Icons.favorite;
      message = "You liked $name";
    } else if (action == "dislike") {
      bgColor = Colors.red;
      icon = Icons.close;
      message = "You disliked $name";
    } else {
      bgColor = Colors.blue;
      icon = Icons.star;
      message = "$name has been added to favourites 💙";
    }

    Get.showSnackbar(
      GetSnackBar(
        message: message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
        backgroundColor: bgColor,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }


  Future<void> handleLikeSwipe(String currentUserId, String targetUserId, Map<String, dynamic> swipedUser) async {
    final swipeDocId = "${currentUserId}_$targetUserId";
    final reverseSwipeDocId = "${targetUserId}_$currentUserId";

    final swipesRef = FirebaseFirestore.instance.collection('swipes');
    final notifRef = FirebaseFirestore.instance.collection('users');

    // Record the swipe
    await swipesRef.doc(swipeDocId).set({
      "swiperId": currentUserId,
      "targetId": targetUserId,
      "liked": true,
      "timestamp": FieldValue.serverTimestamp(),
    });

    // Check if reverse swipe exists (target also liked currentUser)
    final reverseSwipe = await swipesRef.doc(reverseSwipeDocId).get();

    if (reverseSwipe.exists && reverseSwipe['liked'] == true) {
      // ✅ It's a match!
      await notifRef.doc(currentUserId).collection('notifications').add({
        "fromUserId": targetUserId,
        "fromUserName": swipedUser['name'],
        "fromUserImage": swipedUser['image'],
        "type": "match",
        "createdAt": FieldValue.serverTimestamp(),
      });

      await notifRef.doc(targetUserId).collection('notifications').add({
        "fromUserId": currentUserId,
        "fromUserName": "You", // replace with actual name
        "fromUserImage": "...",
        "type": "match",
        "createdAt": FieldValue.serverTimestamp(),
      });
    } else {
      // ✅ Just a like notification
      await notifRef.doc(targetUserId).collection('notifications').add({
        "fromUserId": currentUserId,
        "fromUserName": swipedUser['name'],
        "fromUserImage": swipedUser['image'],
        "type": "like",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }





  @override
  void onClose() {
    _progressTimer?.cancel();
    super.onClose();
  }
}
