import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/onboarding_vm.dart';

class OnBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
