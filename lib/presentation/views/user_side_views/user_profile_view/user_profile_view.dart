import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/user_profile_view_controller/user_profile_view_controller.dart';
import 'package:propmeet/presentation/widgets/basic_profile_info_tile.dart';
import 'package:propmeet/presentation/widgets/custom_user_profile_card.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';
import '../../../widgets/custom_user_appBar.dart';
import '../../../widgets/read_only_user_profile.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});

  final UserProfileViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final selections = controller.profile.value?.selections ?? [];

    final first = selections.length > 0 ? selections[0] : "N/A";
    final second = selections.length > 1 ? selections[1] : "N/A";
    final fifth = selections.length > 4 ? selections[4] : "N/A";

    return Scaffold(
      backgroundColor: AppColors.goldenBackgroundColor,
      appBar: CustomUserAppbar(title: 'App Name',
        trailing:
        IconButton(
          icon: Icon(Icons.refresh, color: AppColors.primary),
          onPressed: () => controller.listenToProfileChanges()
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            //height: MediaQuery.of(context).size.height * 0.78,
            color: AppColors.grey.shade300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomUserProfileCard(),

                  ReadOnlyFieldUserProfile(
                    label: "What are you looking for?",
                    value: first,
                  ),

                  ReadOnlyFieldUserProfile(
                    label: "What type of property it is?",
                    value: second,
                  ),

                  ReadOnlyFieldUserProfile(
                    label: "What`s your timeline to $first it for?",
                    value: fifth,
                  ),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Some Basic Information', style:  TextStyle(
                          fontSize: Responsive.fontSize(4),
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding:  EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey.shade400),
                      ),
                      child: Column(
                        children: [
                          BasicProfileInfoTile(
                            label: "Current Location",
                            value: controller.profile.value?.location ?? "N/A",
                          ),
                          BasicProfileInfoTile(
                            label: "Progress",
                            value:
                            controller.profile.value?.progress.toString() ?? "N/A",
                          ),

                          BasicProfileInfoTile(
                            label: "Property Value",
                            value:
                            controller.profile.value?.propertyDetails.value ??
                                "N/A",
                          ),
                          BasicProfileInfoTile(
                            label: "Bedrooms",
                            value:
                            controller.profile.value?.propertyDetails.bedrooms ??
                                "N/A",
                          ),
                          BasicProfileInfoTile(
                            label: "Bathrooms",
                            value:
                            controller.profile.value?.propertyDetails.bathrooms ??
                                "N/A",
                          ),
                          BasicProfileInfoTile(
                            label: "Car Space",
                            value:
                            controller.profile.value?.propertyDetails.carSpaces ??
                                "N/A",
                          ),
                          BasicProfileInfoTile(
                            label: "Land Space",
                            value:
                            controller.profile.value?.propertyDetails.landSize ??
                                "N/A",
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
