import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/user_profile_view_controller/user_profile_view_controller.dart';
import 'package:propmeet/presentation/widgets/custom_user_profile_card.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

import '../../../widgets/custom_user_appBar.dart';
import '../../../widgets/select_section_field_user_profile.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});

  final UserProfileViewController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.goldenBackgroundColor,
      appBar: CustomUserAppbar(title: 'App Name'),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.78,
            color: AppColors.grey.shade300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomUserProfileCard(),
                  SelectSectionFieldUserProfile(
                    label: "What are you looking for?",
                    selectedValue: controller.lookingFor,
                    options: controller.lookingForOptions,
                    onSelected: controller.updateLookingFor,
                  )
              ,
                  SelectSectionFieldUserProfile(
                    label: "What type of property is it?",
                    selectedValue: controller.propertyType,
                    options: controller.propertyTypeOptions,
                    onSelected: controller.updatePropertyType,
                  ),
                  SelectSectionFieldUserProfile(
                    label: "Where’s your property located?",
                    selectedValue: controller.location,
                    options: controller.locationOptions,
                    onSelected: controller.updateLocation,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
