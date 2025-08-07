import 'package:get/get.dart';
import '../network/network_checker.dart';

class NetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkChecker());
  }
}
