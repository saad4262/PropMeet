import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_chat_view_controller/agent_chat_view_controller.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';
import '../../../widgets/custom_user_appBar.dart';

class AgentChatView extends StatelessWidget {
 AgentChatView({super.key});

  final AgentChatViewController controller=Get.find();

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
                  color: AppColors.grey.shade300,
                  child: Column(
                      children: [
                        Text('chatview')
                        ]
                  )
              ),
            )
        )

    );
  }
}
