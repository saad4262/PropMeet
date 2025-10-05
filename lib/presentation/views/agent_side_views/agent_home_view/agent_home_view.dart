import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import '../../../../core/enum/enum.dart';
import '../../../../domain/viewmodels/agent_side_controller/agent_home_view_controller/agent_home_view_controller.dart';
import '../../../../model/user_model/user_model.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/custom_user_appBar.dart';
import '../../user_side_views/home_view/home_custom_widgets/loading_animation.dart';
import 'custom_agent_home_widgets/agent_card_widget.dart';

class AgentHomeView extends StatelessWidget {
  AgentHomeView({super.key});

  final AgentHomeViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenBackgroundColor,
      appBar: CustomUserAppbar(
        title: 'App Name',
        notification: () {
          Get.toNamed(AppRoutes.notificationScreenAgent);
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
               // height: MediaQuery.of(context).size.height * 0.78,
                decoration: BoxDecoration(color: AppColors.white),
                child: Center(
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
                              'John, We are finding all users \nfor you right now',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: Responsive.fontSize(4)),
                            ),
                          ],
                        ),
                      );
                    }



                    // return CardSwiper(
                    //   allowedSwipeDirection: const AllowedSwipeDirection.only(
                    //     left: true,
                    //     right: true,
                    //   ),
                    //   controller: controller.swiperController,
                    //   cardsCount: controller.currentCards.length,
                    //   numberOfCardsDisplayed: controller.currentCards.length.clamp(1, 3),
                    //   isLoop: true,
                    //   onSwipe: controller.onSwipe,
                    //   cardBuilder: (context, index, percentX, percentY) {
                    //     final UserModel card = controller.currentCards[index];
                    //
                    //     return Obx(() {
                    //       final isLiked = controller.likedNames.contains(card.name);
                    //       final swipeAction = controller.swipeAction.value;
                    //       final swipedCardName = controller.swipedCardName.value;
                    //
                    //       final previewAction = controller.swipePreviewDirection.value;
                    //       final previewName = controller.swipePreviewCardName.value;
                    //
                    //       final shouldAnimateLike =
                    //           (previewAction == SwipeAction.like && previewName == card.name) ||
                    //               (swipeAction == SwipeAction.like && swipedCardName == card.name);
                    //
                    //       final shouldAnimateDislike =
                    //           (previewAction == SwipeAction.dislike && previewName == card.name) ||
                    //               (swipeAction == SwipeAction.dislike && swipedCardName == card.name);
                    //
                    //       return AgentCardWidget(
                    //         user: {
                    //           "name": card.email,
                    //           "email": card.email,
                    //         //  "image": card.profileImage,
                    //        //   "location": card.location,
                    //           "location": "Lahore, Punjab",
                    //           "bedrooms": card.propertyDetails.bedrooms.toString(),
                    //           "bathrooms": card.propertyDetails.bathrooms.toString(),
                    //           "parking": card.propertyDetails.carSpaces.toString(),
                    //           "landSize": card.propertyDetails?.landSize?.toString(),
                    //           "propertyType":card.selections[1].toString(),
                    //           "goal": (card.selections != null && card.selections!.isNotEmpty)
                    //               ? card.selections![0]
                    //               : null,
                    //           "timeline": (card.selections != null && card.selections!.length > 4)
                    //               ? card.selections![4]
                    //               : null,
                    //           "valueRange": card.propertyDetails?.value,
                    //         },
                    //         progress: controller.progress.value,
                    //         isLiked: isLiked,
                    //         swipeAction: shouldAnimateLike
                    //             ? SwipeAction.like
                    //             : shouldAnimateDislike
                    //             ? SwipeAction.dislike
                    //             : SwipeAction.none,
                    //         swipedCardName: card.name ?? "",
                    //        previewAction: previewAction,
                    //         previewName: previewName,
                    //       );
                    //     });
                    //   },
                    // );

                    return controller.currentCards.isEmpty
                        ? Center(
                      child: Text(
                        "No users available",
                        style: TextStyle(fontSize: Responsive.fontSize(5)),
                      ),
                    )
                        : CardSwiper(
                      allowedSwipeDirection: const AllowedSwipeDirection.only(
                        left: true,
                        right: true,
                      ),
                      controller: controller.swiperController,
                      cardsCount: controller.currentCards.length,
                      numberOfCardsDisplayed: controller.currentCards.length.clamp(1, 3),
                      isLoop: false, // keep false to avoid looping empty
                      onSwipe: controller.onSwipe,
                      cardBuilder: (context, index, percentX, percentY) {
                        final UserModel card = controller.currentCards[index];
                        return AgentCardWidget(
                          user: {
                            "name": card.email,
                            "email": card.email,
                            "location": "Lahore, Punjab",
                            "bedrooms": card.propertyDetails.bedrooms.toString(),
                            "bathrooms": card.propertyDetails.bathrooms.toString(),
                            "parking": card.propertyDetails.carSpaces.toString(),
                            "landSize": card.propertyDetails.landSize?.toString(),
                            "propertyType": card.selections.isNotEmpty && card.selections.length > 1
                                ? card.selections[1].toString()
                                : null,
                            "goal": (card.selections.isNotEmpty) ? card.selections[0] : null,
                            "timeline": (card.selections.length > 4) ? card.selections[4] : null,
                            "valueRange": card.propertyDetails.value,
                          },
                          progress: controller.progress.value,
                          isLiked: controller.likedNames.contains(card.name),
                          swipeAction: controller.swipeAction.value,
                          swipedCardName: controller.swipedCardName.value,
                          previewAction: controller.swipePreviewDirection.value,
                          previewName: controller.swipePreviewCardName.value,
                        );
                      },
                    );


                  }),
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const SizedBox.shrink(); // hide buttons while loading
              }
              return Stack(
                children: [
                  Positioned(
                    left: 50,
                    bottom: 30,
                    child: _buildIconButton(
                      Icons.close,
                      AppColors.goldenBackgroundColor,
                          () {
                        controller.swiperController.swipe(CardSwiperDirection.left);
                      },
                    ),
                  ),
                  Positioned(
                    right: 50,
                    bottom: 30,
                    child: _buildIconButton(
                      Icons.check,
                      Colors.blue,
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
