import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/splash_vm.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
