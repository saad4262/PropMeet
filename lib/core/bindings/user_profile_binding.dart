import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/setupprofile_vm.dart';
import 'package:propmeet/domain/viewmodels/splash_vm.dart';

class ProfileSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSetup>(() => ProfileSetup());
  }
}
