import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class PremiumCardsAgent extends StatelessWidget {
  final String cardName;
  final List<Color> gradientColors;
  final Color cardColor;

  const PremiumCardsAgent({
    super.key,
    required this.cardName,
    required this.gradientColors, required this.cardColor,
  });

  final List<Map<String, dynamic>> features = const [
    {"title": "See who Likes You", "free": false, "gold": true},
    {"title": "Top Picks", "free": false, "gold": true},
    {"title": "More Likes Per Month", "free": false, "gold": true},
  ];

  @override
  Widget build(BuildContext context) {
    final cardGradient = LinearGradient(

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: const [0.05,0.2, 0.4,0.6, 0.8,1.0], // makes the gradient smoother
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: (){

          Get.toNamed(AppRoutes.agentSubscriptionPlan);

        },
        child: Container(
          height: Responsive.screenHeight * 0.23,
          width: Responsive.screenWidth * 0.88,
          decoration: BoxDecoration(
            gradient: cardGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: cardColor, width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.homeIcon,
                      width: 28,
                      height: 28,
                      color: AppColors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'App Name',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(4.2),
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 4),

                    /// Card Name Badge (Gold / Silver)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: cardGradient,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        cardName,
                        style: TextStyle(
                          fontSize: Responsive.fontSize(2.5),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// Premium Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                      gradient: cardGradient,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Premium',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(2.5),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// What's Included Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "What's Included",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(3.2),
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text("Free",
                            style: TextStyle(
                                fontSize: Responsive.fontSize(2.8),
                                fontWeight: FontWeight.w500,
                                color: AppColors.black)),
                        const SizedBox(width: 30),
                        Text(cardName,
                            style: TextStyle(
                                fontSize: Responsive.fontSize(2.8),
                                fontWeight: FontWeight.w500,
                                color: AppColors.black)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),


                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: features.length,
                    itemBuilder: (context, index) {
                      final item = features[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item["title"],
                              style: TextStyle(
                                fontSize: Responsive.fontSize(2.8),
                                color: AppColors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  item["free"] ? Icons.done : Icons.lock,
                                  size: 20,
                                  color: item["free"]
                                      ? Colors.green
                                      : AppColors.black,
                                ),
                                const SizedBox(width: 30),
                                Icon(
                                  item["gold"] ? Icons.done : Icons.lock,
                                  size: 20,
                                  color: item["gold"]
                                      ?AppColors.black
                                      : AppColors.black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
