import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/presentation/widgets/custom_button.dart';
import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/utils/responsive_utils.dart';
import '../../../../../shared/config/app_assets/app_assets.dart';
import '../../../../../domain/viewmodels/agent_side_controller/agent_profile_view_controller/agent_edit_profile_view_controller.dart';
import '../../../widgets/custom_user_appBar.dart';

class AgentEditProfileView extends StatelessWidget {
  AgentEditProfileView({super.key});

  final AgentEditProfileViewController controller =
  Get.put(AgentEditProfileViewController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomUserAppbar(
        title: "Edit Profile",
        trailing: Obx(
          () => IconButton(
            icon: Icon(controller.isEditing.value ? Icons.check : Icons.edit),
            onPressed: () {
              if (controller.isEditing.value) {
                controller.saveProfile();
              } else {
                controller.toggleEdit();
              }
            },
          ),
        ),
      ),
      body: Obx(() {
        final data = controller.agentData.value;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileInfoCard(controller),
              const SizedBox(height: 12),
              _buildExperienceCard(controller),
              const SizedBox(height: 12),
              _buildFeeCard(controller),
              const SizedBox(height: 12),
              _buildPerformanceCard(controller),
              const SizedBox(height: 12),
              Center(child: CustomButton(width: 200, height: 50, text: 'Close', onPressed: (){Get.back();}))
              ,const SizedBox(height: 12),
            ],
          ),
        );
      }),

    );
  }

  Widget _buildProfileInfoCard(AgentEditProfileViewController c) {
    return _card(
      title: "Profile Information",
      children: [
        _buildTextField("First Name", c.firstNameController, c.isEditing.value),
        _buildTextField("Last Name", c.lastNameController, c.isEditing.value),
        _buildTextField("Title", c.titleController, c.isEditing.value),
        _buildTextField("Bio", c.bioController, c.isEditing.value, maxLines: 3),
      ],
    );
  }

  Widget _buildExperienceCard(AgentEditProfileViewController c) {
    return _card(
      title: "Experience & Rating",
      children: [
        _buildDropdown(
          "Service Provided",
          c.serviceProvided,
          c.serviceOptions,
          c.isEditing.value,
        ),
        _buildTextField(
          "Experience",
          c.experienceController,
          c.isEditing.value,
        ),
        _buildTextField("Rating", c.ratingController, c.isEditing.value),
        _buildTextField("Reviews", c.reviewCountController, c.isEditing.value),
      ],
    );
  }

  Widget _buildFeeCard(AgentEditProfileViewController c) {
    return _card(
      title: "Fee Details",
      children: [
        _buildDropdown(
          "Fee Structure",
          c.feeStructure,
          c.feeOptions,
          c.isEditing.value,
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(AgentEditProfileViewController c) {
    return _card(
      title: "Performance History",
      children: [
        _buildTextField(
          "Median Days on Market",
          c.medianDaysController,
          c.isEditing.value,
        ),
        _buildTextField(
          "Currently Managing",
          c.managingController,
          c.isEditing.value,
        ),
      ],
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.fontSize(4),
                  color: AppColors.blueMain,
                ),
              ),
              const SizedBox(height: 10),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool editable, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child:
          editable
              ? TextField(
                controller: controller,
                maxLines: maxLines,
                style: TextStyle(fontSize: Responsive.fontSize(4)),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: Responsive.fontSize(3),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              )
              : _infoItem(label, controller.text),
    );
  }

  Widget _buildDropdown(
    String label,
    RxString value,
    List<String> options,
    bool editable,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child:
          editable
              ? Obx(
                () => DropdownButtonFormField<String>(
                  value: value.value,
                  onChanged: (v) => value.value = v!,
                  decoration: InputDecoration(
                    labelText: label,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  items:
                      options
                          .map(
                            (opt) => DropdownMenuItem(
                              value: opt,
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(4),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              )
              : _infoItem(label, value.value),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: Responsive.fontSize(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : "-",
          style: TextStyle(fontSize: Responsive.fontSize(3)),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
