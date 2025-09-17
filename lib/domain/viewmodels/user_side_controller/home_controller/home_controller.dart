import 'dart:async';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

import '../../../../presentation/views/user_side_views/home_view/home_custom_widgets/card_items.dart';

class HomeController extends GetxController {
  final CardSwiperController swiperController = CardSwiperController();
  final RxInt currentIndex = 0.obs;
  final RxDouble progress = 0.0.obs;

  late Timer _progressTimer;

  final List<Map<String, String>> allUsers = [
    {'name': 'Ahmad', 'image': 'https://randomuser.me/api/portraits/men/32.jpg'},
    {'name': 'Ali', 'image': 'https://randomuser.me/api/portraits/men/41.jpg'},
    {'name': 'Charlie', 'image': 'https://randomuser.me/api/portraits/men/65.jpg'},
    {'name': 'Ping', 'image': 'https://randomuser.me/api/portraits/women/21.jpg'},
    {'name': 'Flying Man', 'image': 'https://randomuser.me/api/portraits/men/83.jpg'},
    {'name': 'Adele', 'image': 'https://randomuser.me/api/portraits/women/50.jpg'},
    {'name': 'Naina', 'image': 'https://randomuser.me/api/portraits/women/44.jpg'},
    {'name': 'Sally', 'image': 'https://randomuser.me/api/portraits/women/62.jpg'},
  ];

  final RxList<Map<String, String>> currentCards = <Map<String, String>>[].obs;
  final RxSet<String> likedNames = <String>{}.obs;

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
    startProgressTimer(); // Start for the first card
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
        autoSwipeLeft();
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

  bool onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    _progressTimer.cancel();

    final swipedUser = currentCards[previousIndex];
    this.currentIndex.value = currentIndex ?? previousIndex;

    swipedCardName.value = swipedUser['name']!;

    if (direction == CardSwiperDirection.right) {
      likedNames.add(swipedUser['name']!);
      swipeAction.value = SwipeAction.like;
      showSnackBar(swipedUser['name']!);
    } else if (direction == CardSwiperDirection.left) {
      swipeAction.value = SwipeAction.dislike;
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

  void showSnackBar(String name) {
    Get.showSnackbar(
      GetSnackBar(
        title: 'Liked!',
        message: 'You liked $name',
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void onClose() {
    _progressTimer.cancel();
    super.onClose();
  }
}
