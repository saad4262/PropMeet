import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../shared/config/app_assets/app_assets.dart';
import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/utils/responsive_utils.dart';
import 'card_profile_widgets.dart';

class CardItem extends StatelessWidget {
  final String name;
  final String distance;
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
    required this.previewName, required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(AppAssets.verifiedIcon, width: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$distance km away",
                    style: TextStyle(
                      fontSize: Responsive.fontSize(4),
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.2,
                      children: [
                        CardProfileWidgets(
                          title: 'Experience',
                          subtitle: '5+ years',
                          icon: Icons.work,
                          iconColor: AppColors.black,
                        ),
                        CardProfileWidgets(),
                        CardProfileWidgets(
                          title: 'Rating',
                          subtitle: '4.8',
                          icon: Icons.star,
                          iconColor: Colors.yellow,
                        ),
                        CardProfileWidgets(
                          title: 'Location',
                          subtitle: 'NY, USA',
                          icon: Icons.location_on,
                          iconColor: Colors.black,
                        ),
                        CardProfileWidgets(
                          title: 'Agency',
                          subtitle: 'ABC Realty',
                          icon: Icons.apartment,
                          iconColor: AppColors.black,
                        ),
                        CardProfileWidgets(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


enum SwipeAction { none, like, dislike }
