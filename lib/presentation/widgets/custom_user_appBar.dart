import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/utils/responsive_utils.dart';

class CustomUserAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onLeadingPressed;

  const CustomUserAppbar({
    super.key,
    required this.title,
    this.trailing,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(5),
        vertical: Responsive.height(1),
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             SvgPicture.asset(
               AppAssets.homeIcon, width: 20
               ,color: AppColors.primary,
             ),
              SizedBox(width: Responsive.width(4),),
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

              // Trailing (Filter icon or empty box to balance)
              trailing ??
                  SizedBox(
                    width: Responsive.width(6), // keep symmetry if no trailing
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
