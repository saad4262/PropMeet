import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_favourite_view_controller/agent_favourite_view_controller.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';

class AgentFavouriteView extends StatelessWidget {
   AgentFavouriteView({super.key});

   final AgentFavouriteViewController controller=Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Agnt favourite', style: TextStyle(fontSize: Responsive.fontSize(3), color: AppColors.black),),
      ),

    );
  }
}
