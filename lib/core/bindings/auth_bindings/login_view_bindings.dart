import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/auth_controllers/login_view_controller.dart';

class LoginViewBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LoginViewController>(() => LoginViewController());
  }
}

