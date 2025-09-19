import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';

import '../../../../presentation/views/user_side_views/home_view/home_custom_widgets/card_items.dart';
import '../favourites_view_controller/favourite_view_controller.dart';

class HomeController extends GetxController {

  final FavouriteViewController favouriteController = Get.find();

  final CardSwiperController swiperController = CardSwiperController();
  final RxInt currentIndex = 0.obs;
  final RxDouble progress = 0.0.obs;

  late Timer _progressTimer;

  final List<Map<String, String>> allUsers = [
    {'name': 'Ahmad', 'image': AppAssets.user1, 'distance': '13'},
    {'name': 'Ali', 'image':  AppAssets.user2,'distance': '2'},
    {'name': 'Charlie', 'image':  AppAssets.user3,'distance': '130'},
    {'name': 'Ping', 'image':  AppAssets.user4,'distance': '120'},
    {'name': 'Ahmad', 'image': AppAssets.user1,'distance': '22'},
    {'name': 'Ali', 'image':  AppAssets.user2,'distance': '11'},
    {'name': 'Charlie', 'image':  AppAssets.user3,'distance': '13'},
    {'name': 'Ping', 'image':  AppAssets.user4,'distance': '223'},
  ];

  final RxList<Map<String, String>> currentCards = <Map<String, String>>[].obs;
  final RxSet<String> likedNames = <String>{}.obs;

  final RxBool isLoading = true.obs;

  final RxBool showRefresh = false.obs;

  HomeController() {
    currentCards.value = List<Map<String, String>>.from(allUsers)..shuffle();
  }

  var likeAnimationTrigger = false.obs; // this will trigger my heart wala icon
  var dislikeAnimationTrigger = false.obs;
  var swipeAction = SwipeAction.none.obs;

  var swipedCardName = ''.obs;

  var swipePreviewDirection = SwipeAction.none.obs;
  var swipePreviewCardName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      isLoading.value = false;
    });

    startProgressTimer();
  }

  void shuffleUsers() {
    currentCards.value = List<Map<String, String>>.from(allUsers)..shuffle();
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
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (progress.value >= 1.0) {
        timer.cancel();
    //    autoSwipeLeft();
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
    _progressTimer.cancel();

    final swipedUser = currentCards[previousIndex];
    this.currentIndex.value = currentIndex ?? previousIndex;
    swipedCardName.value = swipedUser['name']!;

    if (direction == CardSwiperDirection.right) {
      likedNames.add(swipedUser['name']!);
      swipeAction.value = SwipeAction.like;

      favouriteController.addToFavourites(swipedUser);

      showSnackBar(swipedUser['name']!, action: "like");
    } else if (direction == CardSwiperDirection.left) {
      swipeAction.value = SwipeAction.dislike;
      showSnackBar(swipedUser['name']!, action: "dislike");
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      swipeAction.value = SwipeAction.none;
      swipedCardName.value = '';
    });

    if (this.currentIndex.value >= currentCards.length) {
      showRefresh.value = true;
      return true;
    }

    startProgressTimer();
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
    } else { // favourite
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


  @override
  void onClose() {
    _progressTimer.cancel();
    super.onClose();
  }
}
