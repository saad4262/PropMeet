import 'package:custom_cached_image/custom_cached_image_with_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_profile_view_controller/agent_profile_view_controller.dart';

import '../../../../domain/viewmodels/agent_side_controller/agent_favourite_view_controller/agent_favourite_view_controller.dart';
import '../../../../shared/config/app_assets/app_assets.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/custom_button.dart';

class AgentProfileCard extends StatelessWidget {
  AgentProfileCard({super.key});
  final AgentProfileViewController controller = Get.find();
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
      height: 220,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: 0.2,
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

                  Obx(() {
                    if (controller.profile.value == null) {
                      return const SizedBox.shrink();
                    }

                    final user = controller.profile.value!;
                    final String profileImage = user.profileImage;
                    final String initial = user.firstName.isNotEmpty
                        ? user.firstName[0].toUpperCase()
                        : "?";

                    // return CircleAvatar(
                    //   radius: 50,
                    //   backgroundColor: Colors.grey,
                    //   backgroundImage: profileImage.isNotEmpty
                    //       ? NetworkImage(profileImage)
                    //       : null,
                    //   child: profileImage.isNotEmpty
                    //       ? Image.network(profileImage, fit: BoxFit.cover)
                    //       : Center(
                    //     child: Text(
                    //       initial,
                    //       style: TextStyle(
                    //         fontSize: Responsive.fontSize(15),
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   )
                    // );
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade400,
                      backgroundImage: profileImage.isNotEmpty
                          ? (profileImage.startsWith('http')
                          ? NetworkImage(profileImage)
                          : AssetImage(profileImage)) as ImageProvider
                          : null,
                      child: profileImage.isEmpty
                          ? Center(
                        child: Text(
                          initial,
                          style: TextStyle(
                            fontSize: Responsive.fontSize(15),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : null,
                    );


                  })
,

                  Positioned(
                    bottom: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
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
                        "${(0.02 * 100).toInt()}%",
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

              SizedBox(width: Responsive.width(5)),
              Column(
                children: [
                  Row(
                    children: [
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.profile.value == null) {
                          return Text(
                            "No profile found",
                            style: TextStyle(
                              fontSize: Responsive.fontSize(3.5),
                              color: AppColors.grey,
                            ),
                          );
                        }

                        final user = controller.profile.value!;
                        return Row(
                          children: [
                            Text(
                              (user.firstName ?? "-").length > 7
                                  ? (user.firstName ?? "-").substring(0, 7)
                                  : (user.firstName ?? "-"),
                              style: TextStyle(
                                fontSize: Responsive.fontSize(4),
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(width: Responsive.width(1)),
                            Text(
                              (user.lastName ?? "-").length > 7
                                  ? (user.lastName ?? "-").substring(0, 7)
                                  : (user.lastName ?? "-"),
                              style: TextStyle(
                                fontSize: Responsive.fontSize(4),
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),

                          ],
                        );
                      }),

                      SizedBox(width: Responsive.width(2)),
                      Image.asset(
                        AppAssets.verifiedIcon,
                        color: AppColors.primary,
                        width: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.height(1)),
                  CustomButton(
                    width: 150,
                    height: 40,
                    text: "Edit Profile",
                    icon: Icons.edit,
                    onPressed: () {
                      Get.toNamed(AppRoutes.agentEditProfileView);
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Responsive.height(2)),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.profile.value == null) {
              return Text(
                "No profile found",
                style: TextStyle(
                  fontSize: Responsive.fontSize(3.5),
                  color: AppColors.grey,
                ),
              );
            }
            final user = controller.profile.value!;
            return Text(
              user.bio?? "-",
              style: TextStyle(
                fontSize: Responsive.fontSize(4),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            );
          }),

          SizedBox(height: 3),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: AppColors.grey,
                size: 20,
              ),
              Obx(() {
                if (controller.profile.value == null) {
                  return Text(
                    '-',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(4),
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                  );
                }
                return Text(
                  controller.profile.value?.createdAt ?? "N/A",
                  style: TextStyle(
                    fontSize: Responsive.fontSize(4),
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey,
                  ),
                );
              }),
            ],
          ),

          // Obx(() {
          //   if (controller.isLoading.value) {
          //     return const Center(child: CircularProgressIndicator());
          //   }
          //
          //   final location = controller.profile.value?.location;
          //
          //   String address = "N/A";
          //
          //   // ✅ Handle both Map and String safely
          //   if (location != null) {
          //     if (location is Map<String, dynamic> && location.containsKey('address')) {
          //       address = location['address'] ?? "N/A";
          //     } else if (location is String) {
          //       address = location as String;
          //     }
          //   }
          //
          //   return Text(
          //     address,
          //     style: TextStyle(
          //       fontSize: Responsive.fontSize(2),
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.grey,
          //     ),
          //   );
          // })



        ],
      ),
    );
  }
}


