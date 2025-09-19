import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class CardProfileWidgets extends StatelessWidget {

  final IconData? icon;
  final String? title;
  final String? subtitle;
  final Color? iconColor;

  const CardProfileWidgets({super.key, this.icon, this.title, this.subtitle, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.height(12),
      width: Responsive.width(35),
      child: Card(
        color: AppColors.white,
        elevation: 4,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle??'4.7', style: TextStyle(fontSize: Responsive.fontSize(3),color: AppColors.black, fontWeight: FontWeight.w600)).paddingSymmetric(horizontal: Responsive.padding(2)),
                Text(
                  title??'Rating',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(2.5),
                    color: AppColors.grey,
                  )).paddingSymmetric(horizontal: Responsive.padding(2),)
              ],
            ),
          Positioned(
            right: 5,
            top: 5,
            child: Icon(icon ?? Icons.star, color: iconColor??Colors.yellow, size: 15),
          ),
        ],
        ),
      ),
    );
  }
}
