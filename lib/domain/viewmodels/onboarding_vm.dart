import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;

  void nextPage() {
    if (pageIndex.value < 2) {
      pageIndex.value++;
    } else {
      Get.offNamed(AppRoutes.loginOptionView);
    }
  }

  void skip() {
    Get.offNamed(AppRoutes.loginView);
  }
}
