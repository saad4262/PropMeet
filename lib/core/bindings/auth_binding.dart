
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:propmeet/domain/viewmodels/auth_vm.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    // Get.lazyPut<GoogleAuthController>(() => GoogleAuthController());
  }
}
