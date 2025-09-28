import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_chat_view_controller/agent_chat_view_controller.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';

class AgentChatView extends StatelessWidget {
 AgentChatView({super.key});

  final AgentChatViewController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text('Agntchat', style: TextStyle(fontSize: Responsive.fontSize(3), color: AppColors.black),),
      ),

    );
  }
}
