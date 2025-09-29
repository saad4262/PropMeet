import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_profile_view_controller/agent_subscription_plan_controller.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class AgentSubscriptionView extends StatelessWidget {
  AgentSubscriptionView({super.key});

  final AgentSubscriptionPlanController controller = Get.find();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "MY SUBSCRIPTION",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          /// Custom TabBar (old style)
          Container(
            height: 50,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                _buildTabButton("Gold", SubscriptionPlan.gold, controller, 0),
                _buildTabButton("Platinum", SubscriptionPlan.silver, controller, 1),
              ],
            ),
          ),

          /// Swipeable Cards
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                controller.selectPlan(
                    index == 0 ? SubscriptionPlan.gold : SubscriptionPlan.silver);
              },
              children: [
                _buildCard(
                  "Gold",
                  AppColors.goldenBackgroundColor,
                  _goldFeatures(),
                ),
                _buildCard(
                  "Platinum",
                  AppColors.silverColor,
                  _platinumFeatures(),
                ),
              ],
            ),
          ),

          /// Subscribe Button (outside card with price)
          Obx(() {
            final isGold = controller.selectedPlan.value == SubscriptionPlan.gold;
            final price = isGold ? "\$9.99 / month" : "\$19.99 / month";
            final colorText=isGold ? AppColors.goldenBackgroundColor :AppColors.silverColor;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: () {
                    isGold
                        ? controller.subscribeToGold()
                        : controller.subscribeToSilver();
                  },
                  child: Text(
                    "Get premium $price",
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorText
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Old Custom Tab Button (working again)
  Widget _buildTabButton(String label, SubscriptionPlan plan,
      AgentSubscriptionPlanController controller, int pageIndex) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedPlan.value == plan;
        final color = plan == SubscriptionPlan.gold
            ? AppColors.goldenBackgroundColor
            : AppColors.silverColor;

        return GestureDetector(
          onTap: () {
            controller.selectPlan(plan);
            pageController.animateToPage(
              pageIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                SvgPicture.asset( AppAssets.goldIcon, color: AppColors.black,width: 20, )
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Subscription Card
  Widget _buildCard(String title, Color color, List<Widget> features) {
    return Center(
      child: Container(
        height: Responsive.screenHeight*0.65,
        width: Responsive.screenWidth * 0.85,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.34), color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "$title Subscription",
                style: TextStyle(
                  fontSize: Responsive.fontSize(4),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...features,
          ],
        ),
      ),
    );
  }

  /// Gold Features
  List<Widget> _goldFeatures() {
    return [
      _featureItem("👍 10 Likes per Month", "Show interest in more profiles daily."),
      _featureItem("👀 See Who Liked You (Limited)", "Preview of people who liked you."),
      _featureItem("⚡ Limited Boosts", "Get boosted occasionally."),
      _featureItem("📉 Fewer Ads", "Reduced ads."),
      _featureItem("🔄 10 Rewinds per Month", "Go back if you skipped someone."),
    ];
  }

  /// Platinum Features
  List<Widget> _platinumFeatures() {
    return [
      _featureItem("👍 25 Likes per Month", "Show interest in more profiles daily."),
      _featureItem("👀 See Who Liked You (Unlimited)", "View everyone who liked you."),
      _featureItem("⚡ Unlimited Boosts", "Always boosted."),
      _featureItem("🚫 No Ads", "No ads at all."),
      _featureItem("🔄 25 Rewinds per Month", "Go back if you skipped someone."),
    ];
  }

  /// Feature Item
  Widget _featureItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.fontSize(4),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: Responsive.fontSize(3.5),
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
