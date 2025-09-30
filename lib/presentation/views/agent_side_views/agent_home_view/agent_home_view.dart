import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import '../../../../core/enum/enum.dart';
import '../../../../domain/viewmodels/agent_side_controller/agent_home_view_controller/agent_home_view_controller.dart';
import '../../../../model/user_model/user_model.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../widgets/custom_user_appBar.dart';
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
                height: MediaQuery.of(context).size.height * 0.78,
                decoration: BoxDecoration(color: AppColors.white),
                child: Center(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.currentCards.isEmpty) {
                      return const Center(child: Text("No users available"));
                    }

                    return CardSwiper(
                      allowedSwipeDirection: const AllowedSwipeDirection.only(
                        left: true,
                        right: true,
                      ),
                      controller: controller.swiperController,
                      cardsCount: controller.currentCards.length,
                      numberOfCardsDisplayed: controller.currentCards.length.clamp(1, 3),
                      isLoop: true,
                      onSwipe: controller.onSwipe,
                      cardBuilder: (context, index, percentX, percentY) {
                        final UserModel card = controller.currentCards[index];

                        return Obx(() {
                          final isLiked = controller.likedNames.contains(card.name);
                          final swipeAction = controller.swipeAction.value;
                          final swipedCardName = controller.swipedCardName.value;

                          final previewAction = controller.swipePreviewDirection.value;
                          final previewName = controller.swipePreviewCardName.value;

                          final shouldAnimateLike =
                              (previewAction == SwipeAction.like && previewName == card.name) ||
                                  (swipeAction == SwipeAction.like && swipedCardName == card.name);

                          final shouldAnimateDislike =
                              (previewAction == SwipeAction.dislike && previewName == card.name) ||
                                  (swipeAction == SwipeAction.dislike && swipedCardName == card.name);

                          return AgentCardWidget(
                            user: {
                              "name": card.name,
                              "email": card.email,
                            //  "image": card.profileImage,
                              "location": card.location,
                              "bedrooms": card.propertyDetails.bedrooms.toString(),
                              "bathrooms": card.propertyDetails.bathrooms.toString(),
                              "parking": card.propertyDetails.carSpaces.toString(),
                              "landSize": card.propertyDetails?.landSize?.toString(),
                              "propertyType": card.propertyDetails?.value,
                              "goal": (card.selections != null && card.selections!.isNotEmpty)
                                  ? card.selections![0]
                                  : null,
                              "timeline": (card.selections != null && card.selections!.length > 4)
                                  ? card.selections![4]
                                  : null,
                              "valueRange": card.propertyDetails?.value,
                            },
                            progress: controller.progress.value,
                            isLiked: isLiked,
                            swipeAction: shouldAnimateLike
                                ? SwipeAction.like
                                : shouldAnimateDislike
                                ? SwipeAction.dislike
                                : SwipeAction.none,
                            swipedCardName: card.name ?? "",
                           previewAction: previewAction,
                            previewName: previewName,
                          );
                        });
                      },
                    );
                  }),
                ),
              ),
            ),
            Stack(
              children: [
                Positioned(
                  left: 50,
                  bottom: 60,
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
                  bottom: 60,
                  child: _buildIconButton(
                    Icons.check,
                    AppColors.primary,
                        () {
                      controller.swiperController.swipe(CardSwiperDirection.right);
                    },
                  ),
                ),
              ],
            ),
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
        child: Icon(icon, size: 35, color: color, fill: 1.0),
      ),
    );
  }
}
