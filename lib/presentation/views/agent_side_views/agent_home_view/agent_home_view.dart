import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_home_view_controller/agent_home_view_controller.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class AgentHomeView extends StatelessWidget {
   AgentHomeView({super.key});

   final AgentHomeViewController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text('Agnt home View', style: TextStyle(fontSize: Responsive.fontSize(3), color: AppColors.black),),
      ),

    );
  }
}
