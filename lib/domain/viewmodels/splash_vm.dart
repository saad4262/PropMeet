import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.onBoarding); 
    });
  }
}
