import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import '../../shared/utils/responsive_utils.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final IconData? icon; // optional icon
  final String? imagePath; // optional image
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPressed,
    this.icon,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration
          (
          border: Border.all(color: AppColors.black, width: 1),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(
            Responsive.radius(30),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.silverColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, color: AppColors.white, size: Responsive.fontSize(5)),
              if (imagePath != null)
                Image.asset(imagePath!, width: 24, height: 24, color: AppColors.white),
              if (icon != null || imagePath != null) SizedBox(width: Responsive.width(2)),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: Responsive.fontSize(4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
