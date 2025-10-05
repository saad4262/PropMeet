import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../domain/viewmodels/user_side_controller/top_agent_view_controller/top_agent_view_controller.dart';
import '../../../../shared/config/app_assets/app_assets.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/custom_user_appBar.dart';
import '../../../widgets/user_agents_cards.dart';

class TopAgentView extends StatelessWidget {
  TopAgentView({super.key});

  final TopAgentViewController controller = Get.put(TopAgentViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenBackgroundColor,
      appBar: CustomUserAppbar(title: 'App Name'),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
           // height: MediaQuery.of(context).size.height * 0.78,
            decoration: BoxDecoration(
              color: AppColors.white,
           //   borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOP AGENTS',
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
                      if (controller.agents.isEmpty) {
                        return Center(child: Text("No agents found", style: TextStyle(fontSize: Responsive.fontSize(4)),));
                      }

                      return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: controller.agents.length,
                        itemBuilder: (context, index) {
                          final agent = controller.agents[index];

                          // Build display name (first + last)
                          final displayName = "${agent.firstName} ${agent.lastName}".trim().isEmpty
                              ? "Unknown"
                              : "${agent.firstName} ${agent.lastName}".trim();

                          return UserAgentsCards(
                            imagePath: (agent.profileImage.isNotEmpty)
                                ? agent.profileImage
                                : AppAssets.user1,
                            name: displayName,
                            distance: "Hi", // static text
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
