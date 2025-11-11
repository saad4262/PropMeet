import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/constants/app_colors.dart';
import '../../shared/utils/responsive_utils.dart';

class BasicProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const BasicProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey.shade800,
                  fontSize: Responsive.fontSize(3.5),
                ),
              ),
              const SizedBox(width: 8),
             Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Responsive.fontSize(3.5),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),

        Divider(
          color: AppColors.grey.shade300,
          thickness: 1,
          height: 1,
        ).paddingSymmetric(horizontal: Responsive.padding(2)),
      ],
    );
  }
}
