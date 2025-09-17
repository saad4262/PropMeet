import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/top_agent_view_controller/top_agent_view_controller.dart';

import '../../../widgets/custom_user_appBar.dart';

class TopAgentView extends StatelessWidget {
  TopAgentView({super.key});


  final TopAgentViewController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomUserAppbar(
        title: 'App Name',

      ),
      body: Center(
        child: Text('top agentView'),
      ),
    );
  }
}
