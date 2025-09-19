import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class SelectSectionFieldUserProfile extends StatelessWidget {
  final String label;
  final RxString selectedValue;
  final List<String> options;
  final void Function(String) onSelected;

  const SelectSectionFieldUserProfile({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        SizedBox(height: Responsive. height(1)),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: options
                        .map(
                          (e) => ListTile(
                        title: Text(
                          e,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: Responsive.fontSize(3),
                          ),
                        ),
                        trailing: selectedValue.value == e
                            ? const Icon(Icons.check,
                            color: Colors.green, size: 20)
                            : null,
                        onTap: () {
                          onSelected(e);
                          Get.back();
                        },
                      ),
                    )
                        .toList(),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedValue.value,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(3.5),
                      color: AppColors.grey,
                    ),
                  ),
                Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
