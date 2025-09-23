import 'package:flutter/material.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class ReadOnlyFieldUserProfile extends StatelessWidget {
  final String label;
  final String value;

  const ReadOnlyFieldUserProfile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontSize: Responsive.fontSize(4),
            ),
          ),
          SizedBox(height: Responsive.height(1)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: Responsive.fontSize(3.5),
                fontWeight: FontWeight.w400,
                color: AppColors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
