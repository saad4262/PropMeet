import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_all_users_controller/top_user_controller.dart';
import '../../../../shared/config/app_assets/app_assets.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/custom_user_appBar.dart';

class TopUsersView extends StatelessWidget {
  TopUsersView({super.key});

  final TopUserController controller = Get.put(TopUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenBackgroundColor,
      appBar: CustomUserAppbar(title: 'App Name'),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
          //  height: MediaQuery.of(context).size.height * 0.78,
            decoration: BoxDecoration(
              color: AppColors.white,
            //  borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOP USERS',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: Responsive.fontSize(6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Responsive.height(2)),

                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.users.isEmpty) {
                        return const Center(child: Text("No users found"));
                      }

                      return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          final user = controller.users[index];
                          return _UserCard(user: user);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class _UserCard extends StatelessWidget {
  final dynamic user;
  const _UserCard({required this.user});

  String _extractNameFromEmail(String email) {
    if (email.isEmpty) return "User";
    return email.split("@").first;
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user.displayName?.isNotEmpty == true
        ? user.displayName!
        : _extractNameFromEmail(user.email);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Responsive.height(2)),
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.goldenBackgroundColor,
                    width: 5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60), // Controls how "oval" it looks
                  child: Container(
                    width: 70,  // slightly wider
                    height: 85, // slightly taller → egg shape
                    color: AppColors.primary,
                    alignment: Alignment.center,
                    child: Text(
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : "?",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),


            // Center(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(
            //         color: AppColors.goldenBackgroundColor,
            //         width: 5,
            //       ),
            //     ),
            //     child: CircleAvatar(
            //       radius: 30,
            //       backgroundColor: AppColors.primary,
            //       child: Text(
            //         displayName.isNotEmpty ? displayName[0].toUpperCase() : "?",
            //         style: const TextStyle(
            //           fontSize: 22,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            SizedBox(height: Responsive.height(1.5)),
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: Responsive.width(2)),
                      Image.asset(
                        AppAssets.verifiedIcon,
                        color: AppColors.goldenBackgroundColor,
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                 Text(
                 //  "lahore",
                  user.location.isNotEmpty ? user.location : "--",
                   style: TextStyle(
                     color: Colors.grey.shade300,
                     fontSize: 13,
                   ),
                   softWrap: true,
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                 ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
