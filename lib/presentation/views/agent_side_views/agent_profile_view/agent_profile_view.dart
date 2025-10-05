import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_profile_view_controller/agent_profile_view_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../shared/config/app_assets/app_assets.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/agent_plan_card.dart';
import '../../../widgets/custom_user_appBar.dart';
import '../../../widgets/premium_cards_agent.dart';
import 'agent_profile_card.dart';

class AgentProfileView extends StatelessWidget {
  AgentProfileView({super.key});

  final AgentProfileViewController controller = Get.find();

  final plans = [
    {"text": "Get More Likes", "icon": AppAssets.favouriteIcon},
    {"text": "Boost Profile", "icon": AppAssets.bonusIcon},
    {"text": "Subscribe", "icon": AppAssets.homeIcon},
  ];

  final PageController _pageController = PageController(viewportFraction: 0.85);

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
            color: AppColors.grey.shade300,
            child: Column(
              children: [
                AgentProfileCard(),
                SizedBox(height: Responsive.height(2)),
                SizedBox(
                  height: Responsive.height(21),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12, top: 4),
                        child: AgentPlanCard(
                          text: plans[index]["text"]!,
                          iconPath: plans[index]["icon"]!,
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Responsive.height(0.5)),
                SizedBox(
                  height: Responsive.height(26),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          children: [
                            PremiumCardsAgent(
                              cardName: 'Gold',
                              cardColor: AppColors.goldenBackgroundColor,
                              gradientColors: [
                                Colors.white,
                                const Color(0xFFF9E9B0),
                                const Color(0xFFD3AD48),
                              const  Color(0xFFF3E9B4),
                                const Color(0xFFD8C77D),
                                Colors.white,
                              ],
                            ),
                            PremiumCardsAgent(
                              cardColor: AppColors.silverColor,
                              cardName: 'Platinum',
                              gradientColors: [
                                Colors.white,
                                const Color(0xFFD1D1D1),
                                const Color(0xFFE9E9E9),
                                const Color(0xFFE9E9E9),
                                const Color(0xFFD1D1D1),
                                Colors.white,
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        effect: WormEffect(
                          dotHeight: 10,
                          dotWidth: 10,
                          activeDotColor: AppColors.black,
                          dotColor: Colors.grey.shade400,
                        ),
                      ),
                    ],
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
