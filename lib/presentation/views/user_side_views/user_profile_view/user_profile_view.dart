import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/user_profile_view_controller/user_profile_view_controller.dart';

import '../../../widgets/custom_user_appBar.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});


  final UserProfileViewController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomUserAppbar(
        title: 'App Name',
      ),
      body: Center(
        child: Text('user profiel'),
      ),
    );
  }
}
