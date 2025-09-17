import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/user_side_controller/favourites_view_controller/favourite_view_controller.dart';

import '../../../widgets/custom_user_appBar.dart';

class FavouritesView extends StatelessWidget {
  FavouritesView({super.key});

  final FavouriteViewController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomUserAppbar(
        title: 'App Name',

      ),
      body: Center(
        child: Text('favourite View'),
      ),
    );
  }
}
