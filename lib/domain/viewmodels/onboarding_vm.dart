import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;

  void nextPage() {
    if (pageIndex.value < 2) {
      pageIndex.value++;
    } else {
      Get.offNamed('/home');
    }
  }

  void skip() {
    Get.offNamed('/home');
  }
}
