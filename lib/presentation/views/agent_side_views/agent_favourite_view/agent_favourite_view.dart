import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_favourite_view_controller/agent_favourite_view_controller.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/custom_user_appBar.dart';
import '../../../widgets/user_agents_cards.dart';

class AgentFavouriteView extends StatelessWidget {
  AgentFavouriteView({super.key});

  final AgentFavouriteViewController controller = Get.put(AgentFavouriteViewController());

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
                  Center(
                    child: Text(
                      'users that liked you',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: Responsive.fontSize(4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.height(2)),
                  Expanded(
                    child: Obx(() {
                      return GridView.builder(
                        itemCount: controller.favouriteUsers.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          final user = controller.favouriteUsers[index];
                          return UserAgentsCards(
                            imagePath: AppAssets.user3,
                            name: user.email.split('@')[0],
                            distance: user.location.isNotEmpty ? user.location : "N/A",
                            isVerified: true,
                          );
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
