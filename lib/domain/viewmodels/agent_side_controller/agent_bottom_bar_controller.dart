import 'package:get/get.dart';

class AgentBottomBarController extends GetxController{

  RxInt selectedIndex = 0.obs;

  void changeSelectedIndex (int newIndex){
    selectedIndex.value  = newIndex;
  }
}