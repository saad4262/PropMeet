import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/favourites_view_controller/favourite_view_controller.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/home_controller/home_controller.dart';
import 'package:propmeet/presentation/widgets/custom_user_appBar.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

import 'home_custom_widgets/card_items.dart';
import 'home_custom_widgets/loading_animation.dart';
class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenBackgroundColor,
      appBar: CustomUserAppbar(
        title: 'App Name',
        trailing: IconButton(
          onPressed: () {

          },
          icon: Icon(Icons.menu, color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.78,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PulseAnimation(
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                                border: Border.all(
                                  color: AppColors.goldenBackgroundColor,
                                  width: 5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'J',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'John, We are finding local agents \nfor you right now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Responsive.fontSize(4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return CardSwiper(
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                      left: true,
                      right: true,
                    ),
                    controller: controller.swiperController,
                    cardsCount: controller.currentCards.length,
                    numberOfCardsDisplayed: 3,
                    isLoop: true,
                    onSwipe: controller.onSwipe,
                    cardBuilder: (context, index, percentX, percentY) {
                      final card = controller.currentCards[index];
                      return Obx(() {
                        final isLiked =
                        controller.likedNames.contains(card['name']);
                        final swipeAction = controller.swipeAction.value;
                        final swipedCardName = controller.swipedCardName.value;

                        final previewAction =
                            controller.swipePreviewDirection.value;
                        final previewName =
                            controller.swipePreviewCardName.value;

                        final shouldAnimateLike =
                            (previewAction == SwipeAction.like &&
                                previewName == card['name']) ||
                                (swipeAction == SwipeAction.like &&
                                    swipedCardName == card['name']);
                        final shouldAnimateDislike =
                            (previewAction == SwipeAction.dislike &&
                                previewName == card['name']) ||
                                (swipeAction == SwipeAction.dislike &&
                                    swipedCardName == card['name']);

                        return CardItem(
                          name: card['name']!,
                          imagePath: card['image']!,
                          distance: card['distance']!,
                          progress: controller.progress.value,
                          isLiked: isLiked,
                          swipeAction: shouldAnimateLike
                              ? SwipeAction.like
                              : shouldAnimateDislike
                              ? SwipeAction.dislike
                              : SwipeAction.none,
                          swipedCardName: card['name']!,
                          previewAction: previewAction,
                          previewName: previewName,
                        );
                      });
                    },
                  );
                }),
              ),
            ),

            Obx(() {
              if (controller.isLoading.value) return const SizedBox();

              return Stack(
                children: [
                  Positioned(
                    left: 30,
                    bottom: 10,
                    child: _buildIconButton(Icons.close, Colors.red, () {
                      controller.swiperController
                          .swipe(CardSwiperDirection.left);
                    }),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 35,
                    child:
                    _buildIconButton(Icons.favorite, AppColors.primary, () {
                      final currentCard = controller.currentCards[controller.currentIndex.value];
                      controller.favouriteController.addToFavourites(currentCard);
                      controller.showSnackBar(currentCard['name']!, action: "favourite");
                      controller.swiperController.swipe(CardSwiperDirection.right);
                    }),

                  ),
                  Positioned(
                    right: 30,
                    bottom: 10,
                    child: _buildIconButton(Icons.check, Colors.green, () {}),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.black,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, size: 30, color: color),
      ),
    );
  }
}
