import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/auth_controllers/login_option_view_controller.dart';

class LoginOptionBindings extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<LoginOptionViewController>(()=>LoginOptionViewController());
  }
}