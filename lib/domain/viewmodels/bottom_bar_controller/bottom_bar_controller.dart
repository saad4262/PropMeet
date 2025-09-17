import 'package:get/get.dart';

class BottomBarController extends GetxController{

  RxInt selectedIndex = 0.obs;

  void changeSelectedIndex (int newIndex){
    selectedIndex.value  = newIndex;
  }

}