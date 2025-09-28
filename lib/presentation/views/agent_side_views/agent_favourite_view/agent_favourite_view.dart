import 'package:flutter/material.dart';

import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/utils/responsive_utils.dart';

class AgentFavouriteView extends StatelessWidget {
  const AgentFavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Agnt favourite', style: TextStyle(fontSize: Responsive.fontSize(3), color: AppColors.black),),
      ),

    );
  }
}
