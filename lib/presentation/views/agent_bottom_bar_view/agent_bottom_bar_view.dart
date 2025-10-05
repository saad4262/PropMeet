import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_bottom_bar_controller.dart';
import 'package:propmeet/presentation/views/agent_side_views/agent_chat_view/agent_chat_view.dart';
import 'package:propmeet/presentation/views/agent_side_views/agent_favourite_view/agent_favourite_view.dart';
import 'package:propmeet/presentation/views/agent_side_views/agent_home_view/agent_home_view.dart';
import 'package:propmeet/presentation/views/agent_side_views/agent_profile_view/agent_profile_view.dart';
import 'package:propmeet/presentation/views/agent_side_views/top_users_view/top_users_view.dart';
import 'package:propmeet/presentation/views/chat_view/chatlist_screen.dart';
import '../../../domain/viewmodels/bottom_bar_controller/bottom_bar_controller.dart';
import '../../../shared/config/app_assets/app_assets.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/responsive_utils.dart';

class AgentBottomBarView extends StatefulWidget {
  const AgentBottomBarView({super.key});

  @override
  State<AgentBottomBarView> createState() => _AgentBottomBarViewState();
}

class _AgentBottomBarViewState extends State<AgentBottomBarView> {
  List screens = <Widget>[

    AgentHomeView(),
    TopUsersView(),
    AgentFavouriteView(),
    ChatListScreen(),
    AgentProfileView(),

  ];

  final AgentBottomBarController barController = Get.find();

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: AppColors.primary,
          body: Obx(() => screens[barController.selectedIndex.value]),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: Responsive.height(10),
            decoration: BoxDecoration(
              color: AppColors.white,
            ),
            child: Obx(
                  () => Column(
                children: [
                  SizedBox(height: Responsive.height(1)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _bottomIconBuilder(index: 0, asset: AppAssets.homeIcon),
                      _bottomIconBuilder(
                        index: 1,
                        asset: AppAssets.topAgentIcon,
                        isBadgeVisible: true,
                        badgeColor: Colors.yellow,
                      ),
                      _bottomIconBuilder(
                        index: 2,
                        asset: AppAssets.favouriteIcon,
                      ),
                      _bottomIconBuilder(
                        index: 3,
                        asset: AppAssets.chatIcon,
                        isBadgeVisible: true,
                        badgeColor: Colors.red,
                        badgeText: "12",
                      ),
                      _bottomIconBuilder(
                        index: 4,
                        asset: AppAssets.userProfileIcon,
                      ),
                    ],
                  ),
                  SizedBox(height: Responsive.height(1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomIconBuilder({
    required int index,
    required String asset,
    bool isBadgeVisible = false,
    Color badgeColor = AppColors.primary,
    String? badgeText,
  }) {
    bool isSelected = barController.selectedIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          barController.selectedIndex.value = index;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Responsive.height(1.5)),
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  asset,
                  width: 25,
                  height: 25,
                  color: isSelected ? AppColors.primary : AppColors.grey,
                ),

                if (isBadgeVisible)
                  Positioned(
                    right: -5,
                    top: -7,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: badgeText != null ? 4 : 0,
                        vertical: badgeText != null ? 1 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        shape:
                        badgeText == null
                            ? BoxShape.circle
                            : BoxShape.rectangle,
                        borderRadius:
                        badgeText != null
                            ? BorderRadius.circular(10)
                            : null,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Center(
                        child:
                        badgeText != null
                            ? Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
