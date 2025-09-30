import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_all_users_controller/top_user_controller.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/custom_user_appBar.dart';

class TopUsersView extends StatelessWidget {
  TopUsersView({super.key});

  final TopUserController controller = Get.put(TopUserController());

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
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOP USERS',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: Responsive.fontSize(6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Responsive.height(2)),

                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.users.isEmpty) {
                        return const Center(child: Text("No users found"));
                      }

                      return GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          final user = controller.users[index];
                          return _UserCard(user: user);
                        },
                      );
                    }),
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

class _UserCard extends StatelessWidget {
  final dynamic user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circle with first letter of email
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blueAccent,
              child: Text(
                user.email.isNotEmpty ? user.email[0].toUpperCase() : "?",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Name or Email
            Text(
              user.name?.isNotEmpty == true ? user.name! : user.email,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Location (instead of km away, show user.location)
            Text(
              user.location.isNotEmpty ? user.location : "Unknown location",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
