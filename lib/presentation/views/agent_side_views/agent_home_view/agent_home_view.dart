import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_home_view_controller/agent_home_view_controller.dart';
import 'package:propmeet/presentation/views/agent_side_views/agent_home_view/custom_agent_home_widgets/agent_card_widget.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import '../../../widgets/custom_user_appBar.dart';

class AgentHomeView extends StatelessWidget {
   AgentHomeView({super.key});

   final AgentHomeViewController controller=Get.find();

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
                  color: AppColors.white,
                ),
                child:
                Center(
                  child: CardSwiper(
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                      left: true,
                      right: true,
                    ),
                    controller: controller.swiperController,
                    cardsCount: controller.currentCards.length,
                    numberOfCardsDisplayed: controller.currentCards.isEmpty
                        ? 1 // fallback, though cardsCount=0 means it won't render
                        : controller.currentCards.length.clamp(1, 3),
                    isLoop: true,
                    onSwipe: controller.onSwipe,
                    cardBuilder: (context, index, percentX, percentY) {
                      final card = controller.currentCards[index];
                      return Obx(() {
                        final isLiked = controller.likedNames.contains(card['name']);
                        final swipeAction = controller.swipeAction.value;
                        final swipedCardName = controller.swipedCardName.value;

                        final previewAction = controller.swipePreviewDirection.value;
                        final previewName = controller.swipePreviewCardName.value;

                        final shouldAnimateLike =
                            (previewAction == SwipeAction.like && previewName == card['name']) ||
                                (swipeAction == SwipeAction.like &&
                                    swipedCardName == card['name']);
                        final shouldAnimateDislike =
                            (previewAction == SwipeAction.dislike &&
                                previewName == card['name']) ||
                                (swipeAction == SwipeAction.dislike &&
                                    swipedCardName == card['name']);

                        return AgentCardWidget(
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
                  ),
                )




              ),
            ),


               Stack(
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
              )
    ]
        )


      )
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

