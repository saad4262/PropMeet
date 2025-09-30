import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/utils/responsive_utils.dart';

class AgentCardProfileWidget extends StatelessWidget {

  final String? icon;
  final String? title;
  final String? subtitle;
  final Color? iconColor;


  const AgentCardProfileWidget({super.key, this.icon, this.title, this.subtitle, this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? "--", style: TextStyle(fontSize: Responsive.fontSize(5), fontWeight: FontWeight.bold),),
            Row(
              children: [
                SvgPicture.asset(icon!, width: 15, color: AppColors.black,),
                SizedBox(width: Responsive.width(2),),
                Text(subtitle ?? "--", style: TextStyle(fontSize: Responsive.fontSize(4), color: AppColors.grey.shade800),),

              ],
            )
          ],
        )
      ),
    );
  }
}