import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:propmeet/domain/viewmodels/bottom_bar_controller/bottom_bar_controller.dart';

import '../../../domain/viewmodels/user_side_controller/chat_view_controller/chat_view_controller.dart';
import '../../../domain/viewmodels/user_side_controller/favourites_view_controller/favourite_view_controller.dart';
import '../../../domain/viewmodels/user_side_controller/home_controller/home_controller.dart';
import '../../../domain/viewmodels/user_side_controller/top_agent_view_controller/top_agent_view_controller.dart';
import '../../../domain/viewmodels/user_side_controller/user_profile_view_controller/user_profile_view_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(() => BottomBarController());
    Get.lazyPut<FavouriteViewController>(() => FavouriteViewController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatViewController>(() => ChatViewController());
    Get.lazyPut<TopAgentViewController>(() => TopAgentViewController());
    Get.lazyPut<UserProfileViewController>(() => UserProfileViewController());
  }
}
