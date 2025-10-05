import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/auth_vm.dart';
import 'package:propmeet/presentation/widgets/custom_button.dart';
import 'package:propmeet/shared/constants/app_colors.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController()); // ✅ GetX controller

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Get.back(); // ✅ Back button se pichle screen par jao
          },
        ),
      ),
      body: Center(
        child: CustomButton(
          width: 150,
          height: 50,
          text: 'Logout',
          onPressed: () async {
            await authController.logout(); // ✅ Proper Firebase logout
          },
        ),
      ),
    );
  }
}
