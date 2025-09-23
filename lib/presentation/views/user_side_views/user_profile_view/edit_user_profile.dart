import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/user_profile_view_controller/edit_user_profile_view_controller.dart';
import 'package:propmeet/presentation/views/user_side_views/user_profile_view/property_detail_section.dart';
import 'package:propmeet/presentation/widgets/custom_button.dart';
import 'package:propmeet/presentation/widgets/custom_user_appBar.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class EditUserProfile extends StatelessWidget {
  EditUserProfile({super.key});

  final controller = Get.put(EditUserProfileViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColors.white,
      appBar:AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text('Edit Profile', style: TextStyle(color: AppColors.black, fontSize: Responsive.fontSize(5), fontWeight: FontWeight.w600),),
      ),
      body: Obx(() {
        if (controller.profile.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.goldenBackgroundColor, width: 3),
                borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildTextField("Full Name", controller.nameController),
                SizedBox(height: Responsive.height(2)),
                _buildTextField("Email", controller.emailController, readOnly: true),
                SizedBox(height: Responsive.height(2)),
                _buildTextField("Location", controller.locationController),

                 SizedBox(height: Responsive.height(4)),


                _buildChoiceSection(
                  "What do you want to do?",
                  ["Sell My Home", "Rent My Property",],
                  controller.sellChoice,
                ),
                SizedBox(height: Responsive.height(2)),
                _buildChoiceSection(
                  "Property Type",
                  ["Home","Apartment", "Townhouse","Land"],
                  controller.propertyType,
                ),
                SizedBox(height: Responsive.height(2)),
                _buildChoiceSection(
                  "Timeline",
                  ["Just Researching", "Selling in 3-6 Months", "Ready to Sell Now"],
                  controller.timeline,
                ),

                SizedBox(height: Responsive.height(2)),

                PropertyDetailsSection(
                  details: controller.profile.value!.propertyDetails,
                  onUpdate: (field, value) {
                    // Update Firestore or local controller here
                    controller.updatePropertyDetail(field, value);
                  },
                ),

                SizedBox(height: Responsive.height(2),)
,                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(width: 200, height: 60, text: 'Svae Profile', onPressed: controller.saveProfile,),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller,
      {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildChoiceSection(String title, List<String> options, RxString selected) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 3,
            children: options.map((option) {
              final isSelected = selected.value == option;
              return ChoiceChip(
                elevation: 1,
                label: Text(option,),
                selected: isSelected,
                onSelected: (_) => selected.value = option,
                selectedColor: AppColors.goldenBackgroundColor
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
