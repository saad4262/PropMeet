import 'package:custom_cached_image/custom_cached_image_with_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:propmeet/shared/constants/app_colors.dart';

class CardItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final double progress;
  final bool isLiked;
  final SwipeAction swipeAction;
  final String swipedCardName;
  final SwipeAction previewAction;
  final String previewName;

  const CardItem({
    required this.name,
    required this.imagePath,
    required this.progress,
    required this.isLiked,
    required this.swipeAction,
    required this.swipedCardName,
    Key? key,
    required this.previewAction,
    required this.previewName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
      ),
      child: Column(
        children: [

          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                 imagePath,
                fit: BoxFit.cover,
                width: double.infinity, height: 50,
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(20),
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style:  TextStyle(
                          fontSize: 20,
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "4km",
                        style: TextStyle(fontSize: 12,  color: AppColors.grey,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Text("Teacher • Any bio/description", style: TextStyle(fontSize: 10, color: AppColors.black,),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum SwipeAction { none, like, dislike }
