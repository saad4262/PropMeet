import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
