import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/chat_view_controller/chat_view_controller.dart';

import '../../../widgets/custom_user_appBar.dart';

class ChatView extends StatelessWidget {
   ChatView({super.key});

  final ChatViewController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomUserAppbar(
        title: 'App Name',

      ),
      body: Center(
        child: Text('Chat View'),
      ),
    );
  }
}
