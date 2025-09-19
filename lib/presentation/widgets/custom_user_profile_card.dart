import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/user_profile_view_controller/user_profile_view_controller.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

import 'custom_button.dart';

class CustomUserProfileCard extends StatelessWidget {
  CustomUserProfileCard({super.key});

  final UserProfileViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Responsive.padding(10)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      height: 250,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Obx(() {
            double progress =
                controller.completedComponents.value / controller.totalComponents;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
            Stack(
            alignment: Alignment.center,
              children: [
                // Background progress ring
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: AppColors.white,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),

                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          stops: const [0.2, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      "J",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(15),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: Responsive.fontSize(2.5),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: Responsive.width(5),),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                fontSize: Responsive.fontSize(4),
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(width: Responsive.width(3),),
                            Image.asset(AppAssets.verifiedIcon, color: AppColors.primary, width: 20,)
                          ],
                        ),
                        SizedBox(height: Responsive.height(1),),
                        CustomButton(
                          width: 120,
                          height: 35,
                          text: "Edit Profile",
                          icon: Icons.edit,
                          onPressed: () {},
                        ),

                      ],
                    )
                  ],
                )
              ],
            );
          }),
          SizedBox(height: 10,),
          Text(
            'Here small bio for both User and Agent',
            style: TextStyle(
              color: AppColors.black,
              fontSize: Responsive.fontSize(4),
            ),
          ),
          SizedBox(height: 3,),
          Row(
            children: [
              Icon(Icons.calendar_month_outlined,
                  color: AppColors.grey, size: 22),
              Text(
                'Joined August 2025',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: Responsive.fontSize(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
