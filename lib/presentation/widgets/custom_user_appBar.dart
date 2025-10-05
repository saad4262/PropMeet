import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/responsive_utils.dart';

class CustomUserAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? notification;

  const CustomUserAppbar({
    super.key,
    required this.title,
    this.trailing,
    this.onLeadingPressed,
    this.notification,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(5),
        vertical: Responsive.height(1),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: const Border(
          bottom: BorderSide(
            color: AppColors.goldenBackgroundColor,
            width: 5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Leading icon
              GestureDetector(
                onTap: onLeadingPressed,
                child: SvgPicture.asset(
                  AppAssets.homeIcon,
                  width: 22,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: Responsive.width(4)),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(6),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),

              // Trailing section (only show notification if callback provided)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (notification != null)
                    IconButton(
                      onPressed: notification,
                      icon: const Icon(
                        Icons.notifications,
                        color: AppColors.primary,
                      ),
                    ),

                  // Optional trailing widget
                  if (trailing != null) trailing!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
