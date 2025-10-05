import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
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
        notification: () {
          Get.toNamed(AppRoutes.notificationScreenUser);
        },
        trailing: IconButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.filterPage);
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
              //  height: MediaQuery.of(context).size.height * 0.78,
                decoration: BoxDecoration(
                  color: AppColors.white,
              //    borderRadius: BorderRadius.circular(20),
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
                            style: TextStyle(fontSize: Responsive.fontSize(4)),
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
                        final isLiked = controller.likedNames.contains(
                          card['name'],
                        );
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
                          swipeAction:
                              shouldAnimateLike
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
                  if (controller.showRefresh.value)
                    Center(
                      child: ElevatedButton(
                        onPressed: controller.shuffleUsers,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 6,
                        ),
                        child: Text("Shuffle again", style: TextStyle(fontSize: Responsive.fontSize(4))),
                      ),
                    ),

                  Positioned(
                    left: 50,
                    bottom: 10,
                    child: _buildIconButton(
                      Icons.close,
                      AppColors.goldenBackgroundColor,
                          () {
                        controller.swiperController.swipe(
                          CardSwiperDirection.left,
                        );
                      },
                    ),
                  ),

                  Positioned(
                    right: 50,
                    bottom: 10,
                    child: _buildIconButton(
                      Icons.check,
                      AppColors.primary,
                          () {
                        controller.swiperController.swipe(CardSwiperDirection.right);
                      },
                    ),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.black,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, size: 20, color: color, fill: 1.0),
      ),
    );
  }
}
