import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_all_users_controller/top_user_controller.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';

class TopUsersView extends StatelessWidget {
TopUsersView({super.key});
 final TopUserController controller=Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Agnt top user', style: TextStyle(fontSize: Responsive.fontSize(3), color: AppColors.black),),
      ),

    );
  }
}
