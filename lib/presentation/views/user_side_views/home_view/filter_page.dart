import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/presentation/widgets/custom_button.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: CustomButton(width:100
            , height: 50
            , text: 'logout', onPressed: (){
          Get.offAllNamed(AppRoutes.login);
            }),
      ),
    );
  }
}
