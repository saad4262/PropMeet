// import 'package:flutter/material.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
// import 'package:get/get.dart';
// import 'package:propmeet/domain/viewmodels/user_side_controller/home_controller/home_controller.dart';
// import 'package:propmeet/presentation/widgets/custom_user_appBar.dart';
// import 'package:propmeet/shared/constants/app_colors.dart';
//
// import 'home_custom_widgets/card_items.dart';
//
// class HomeView extends StatelessWidget {
//   HomeView({super.key});
//
//   final HomeController controller = Get.put(HomeController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomUserAppbar(
//         title: 'App Name',
//         trailing: IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.menu, color: AppColors.primary),
//         ),
//       ),
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.showRefresh.value || controller.currentCards.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircularProgressIndicator(),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: controller.shuffleUsers,
//                     icon: const Icon(Icons.refresh),
//                     label: const Text("Reload Users"),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   color: AppColors.primary.withOpacity(0.1),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: CardSwiper(
//                     allowedSwipeDirection: const AllowedSwipeDirection.only(
//                       left: true,
//                       right: true,
//                     ),
//                     controller: controller.swiperController,
//                     cardsCount: controller.currentCards.length,
//                     numberOfCardsDisplayed: 3,
//                     isLoop: true,
//                     onSwipe: (prevIndex, nextIndex, direction) {
//                       if (nextIndex != null) {
//                         final card = controller.currentCards[nextIndex];
//                         controller.updateSwipePreview(0.1, card['name']!);
//                       }
//                       return true;
//                     },
//                     cardBuilder: (context, index, percentX, percentY) {
//                       final card = controller.currentCards[index];
//
//                       return Obx(() {
//                         final isLiked = controller.likedNames.contains(card['name']);
//                         final swipeAction = controller.swipeAction.value;
//                         final swipedCardName = controller.swipedCardName.value;
//
//                         final previewAction = controller.swipePreviewDirection.value;
//                         final previewName = controller.swipePreviewCardName.value;
//
//                         final shouldAnimateLike = (previewAction == SwipeAction.like && previewName == card['name']) ||
//                             (swipeAction == SwipeAction.like && swipedCardName == card['name']);
//                         final shouldAnimateDislike = (previewAction == SwipeAction.dislike && previewName == card['name']) ||
//                             (swipeAction == SwipeAction.dislike && swipedCardName == card['name']);
//
//                         return CardItem(
//                           name: card['name']!,
//                           imagePath: card['image']!,
//                           progress: controller.progress.value,
//                           isLiked: isLiked,
//                           swipeAction: shouldAnimateLike
//                               ? SwipeAction.like
//                               : shouldAnimateDislike
//                               ? SwipeAction.dislike
//                               : SwipeAction.none,
//                           swipedCardName: card['name']!,
//                           previewAction: previewAction,
//                           previewName: previewName,
//                         );
//                       });
//                     },
//                   ),
//                   // child: CardSwiper(
//                   //   allowedSwipeDirection: const AllowedSwipeDirection.only(
//                   //     left: true,
//                   //     right: true,
//                   //   ),
//                   //   controller: controller.swiperController,
//                   //   cardsCount: controller.currentCards.length,
//                   //   numberOfCardsDisplayed: 3,
//                   //   isLoop: true,
//                   //   onSwipe: controller.onSwipe,
//                   //   cardBuilder: (context, index, percentX, percentY) {
//                   //     final card = controller.currentCards[index];
//                   //
//                   //     controller.updateSwipePreview(0.1 , card['name']!);
//                   //
//                   //     return Obx(() {
//                   //       final isLiked = controller.likedNames.contains(card['name']);
//                   //       final swipeAction = controller.swipeAction.value;
//                   //       final swipedCardName = controller.swipedCardName.value;
//                   //
//                   //       final previewAction = controller.swipePreviewDirection.value;
//                   //       final previewName = controller.swipePreviewCardName.value;
//                   //
//                   //       // 💡 Animate like/dislike
//                   //       final shouldAnimateLike = (previewAction == SwipeAction.like && previewName == card['name']) ||
//                   //           (swipeAction == SwipeAction.like && swipedCardName == card['name']);
//                   //       final shouldAnimateDislike = (previewAction == SwipeAction.dislike && previewName == card['name']) ||
//                   //           (swipeAction == SwipeAction.dislike && swipedCardName == card['name']);
//                   //
//                   //       return CardItem(
//                   //         name: card['name']!,
//                   //         imagePath: card['image']!,
//                   //         progress: controller.progress.value,
//                   //         isLiked: isLiked,
//                   //         swipeAction: shouldAnimateLike
//                   //             ? SwipeAction.like
//                   //             : shouldAnimateDislike
//                   //             ? SwipeAction.dislike
//                   //             : SwipeAction.none,
//                   //         swipedCardName: card['name']!,
//                   //         previewAction: previewAction,
//                   //         previewName: previewName,
//                   //       );
//                   //     });
//                   //   },
//                   // ),
//                 ),
//               ),
//
//               Obx(() {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       AnimatedScale(
//                         scale: controller.swipePreviewDirection.value == SwipeAction.dislike ? 1.2 : 1.0,
//                         duration: const Duration(milliseconds: 300),
//                         child: Icon(Icons.heart_broken, color: Colors.red, size: 60),
//                       ),
//                       AnimatedScale(
//                         scale: controller.swipePreviewDirection.value == SwipeAction.like ? 1.2 : 1.0,
//                         duration: const Duration(milliseconds: 300),
//                         child: Icon(Icons.favorite, color: Colors.green, size: 60),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
