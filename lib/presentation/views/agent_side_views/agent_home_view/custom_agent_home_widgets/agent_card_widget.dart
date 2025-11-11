import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propmeet/presentation/views/agent_side_views/agent_home_view/custom_agent_home_widgets/agent_card_proifle_widget.dart';
import '../../../../../core/enum/enum.dart';
import '../../../../../shared/config/app_assets/app_assets.dart';
import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/utils/responsive_utils.dart';

class AgentCardWidget extends StatelessWidget {
    final Map<String, dynamic> user;
    final double progress;
    final bool isLiked;
    final SwipeAction swipeAction;
    final String swipedCardName;
    final SwipeAction previewAction;
    final String previewName;

    const AgentCardWidget({
        required this.user,
        required this.progress,
        required this.isLiked,
        required this.swipeAction,
        required this.swipedCardName,
        required this.previewAction,
        required this.previewName,
        super.key,
    });

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            height: Responsive.screenHeight * 0.65,
            child: Card(
                elevation: 3,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        /// --- Top Section (Profile Circle + Name + Location) ---
                        Expanded(
                            flex: 4,
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                    ),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        // --- Profile Picture ---
                                        Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: AppColors.goldenBackgroundColor,
                                                    width: 5,
                                                ),
                                            ),
                                            child: _buildProfileImage(),
                                        ),

                                        const SizedBox(height: 8),

                                        // --- Email + Location ---
                                        SizedBox(
                                            height: 50,
                                            child: Card(
                                                color: AppColors.primary.withOpacity(0.36),
                                                elevation: 2,
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 12, vertical: 6),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            Text(
                                                                user["email"] ?? "--",
                                                                style: TextStyle(
                                                                    color: AppColors.white,
                                                                    fontSize: Responsive.fontSize(2.5),
                                                                ),
                                                            ),
                                                            Row(
                                                                children: [
                                                                    const Icon(
                                                                        Icons.location_on_outlined,
                                                                        size: 18,
                                                                        color: Colors.white,
                                                                    ),
                                                                    const SizedBox(width: 4),
                                                                    Text(
                                                                        _truncateLocation(user["location"] ?? "--"),
                                                                        softWrap: true,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            color: AppColors.white,
                                                                            fontSize: Responsive.fontSize(3.5),
                                                                        ),
                                                                    ),

                                                                ],
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),

                        /// --- Bottom Section ---
                        Expanded(
                            flex: 6,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Wrap(
                                                spacing: 20,
                                                runSpacing: 10,
                                                alignment: WrapAlignment.spaceEvenly,
                                                children: [
                                                    _infoRow(AppAssets.bedroomIcon, user["bedrooms"] ?? "--"),
                                                    _infoRow(AppAssets.bathroomIcon, user["bathrooms"] ?? "--"),
                                                    _infoRow(null, user["parking"] ?? "--",
                                                        icon: Icons.directions_car),
                                                    _infoRow(AppAssets.landSizeIcon, user["landSize"] ?? "--"),
                                                    Text(
                                                        user["propertyType"] ?? "--",
                                                        style: TextStyle(
                                                            color: AppColors.grey.shade800,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: Responsive.fontSize(3.5),
                                                        ),
                                                    ),
                                                ],
                                            ),

                                            const SizedBox(height: 12),

                                            /// Profile details (goals, timeline, value)
                                            AgentCardProfileWidget(
                                                title: "What are you looking to do?",
                                                subtitle: user["goal"] ?? "--",
                                                icon: AppAssets.homeOnSaleIcon,
                                            ),
                                            const SizedBox(height: 5),
                                            AgentCardProfileWidget(
                                                title: "Timeline",
                                                subtitle: user["timeline"] ?? "--",
                                                icon: AppAssets.bonusIcon,
                                            ),
                                            const SizedBox(height: 5),
                                            AgentCardProfileWidget(
                                                title: "Approx. property value?",
                                                subtitle: user["valueRange"] ?? "--",
                                                icon: AppAssets.bonusIcon,
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    /// --- Profile Image with fallback logic ---
    /// --- Profile Initial Circle ---
    Widget _buildProfileImage() {
        String email = user["email"]?.toString().trim() ?? "";
        String initial = email.isNotEmpty ? email[0].toUpperCase() : "?";

        return Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blueMain,
            ),
            alignment: Alignment.center,
            child: Text(
                initial,
                style: TextStyle(
                    color: AppColors.white, // text color
                    fontSize: 48, // adjust size as needed
                    fontWeight: FontWeight.bold,
                ),
            ),
        );
    }


    /// --- Info Row ---
    Widget _infoRow(String? asset, dynamic value, {IconData? icon}) {
        if (asset == null || asset.isEmpty) {
            return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Icon(icon ?? Icons.help_outline, size: 20, color: AppColors.black),
                    const SizedBox(width: 4),
                    Text(value?.toString() ?? "--",
                        style: TextStyle(fontSize: Responsive.fontSize(4))),
                ],
            );
        }

        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                SvgPicture.asset(asset, width: 20),
                const SizedBox(width: 4),
                Text(value?.toString() ?? "--",
                    style: TextStyle(fontSize: Responsive.fontSize(3.5))),
            ],
        );
    }
}
String _truncateLocation(String text, {int maxLength = 20}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

