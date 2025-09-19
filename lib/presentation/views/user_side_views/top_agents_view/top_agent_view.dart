import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/top_agent_view_controller/top_agent_view_controller.dart';
import 'package:propmeet/presentation/widgets/user_agents_cards.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

import '../../../../shared/config/app_assets/app_assets.dart';
import '../../../widgets/custom_user_appBar.dart';

class TopAgentView extends StatelessWidget {
  TopAgentView({super.key});

  final List<Map<String, dynamic>> agents = [
    {
      "name": "John Doe",
      "subtitle": "3 km away",
      "image": AppAssets.user1,
      "isVerified": true,
    },
    {
      "name": "Sarah Khan",
      "subtitle": "5 km away",
      "image": AppAssets.user2,
      "isVerified": true,
    },
    {
      "name": "John Doe",
      "subtitle": "3 km away",
      "image": AppAssets.user3,
      "isVerified": true,
    },
    {
      "name": "Sarah Khan",
      "subtitle": "5 km away",
      "image": AppAssets.user4,
      "isVerified": true,
    },
    {
      "name": "John Doe",
      "subtitle": "3 km away",
      "image": AppAssets.user1,

    },
    {
      "name": "Sarah Khan",
      "subtitle": "5 km away",
      "image": AppAssets.user2,
      "isVerified": true,

    },
    {
      "name": "John Doe",
      "subtitle": "3 km away",
      "image": AppAssets.user3,
      "isVerified": true,
    },
    {
      "name": "Sarah Khan",
      "subtitle": "5 km away",
      "image": AppAssets.user4,
      "isVerified": false,
    },
  ];

  final TopAgentViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenBackgroundColor,
      appBar: CustomUserAppbar(title: 'App Name'),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.78,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
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
                  SizedBox(height: Responsive.height(2),),

                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: agents.length,
                      itemBuilder: (context, index) {
                        final agent = agents[index];
                        return UserAgentsCards(
                          imagePath: agent["image"],
                          name: agent["name"],
                          distance: agent["subtitle"],
                          isVerified: agent["isVerified"],
                        );
                      },
                    ),
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
