import 'package:get/get.dart';

class AgentFavouriteViewController extends GetxController {
  final RxList<Map<String, String>> favouriteUsers = <Map<String, String>>[].obs;

  void addToFavourites(Map<String, String> agent) {
    if (!favouriteUsers.any((a) => a['name'] == agent['name'])) {
      favouriteUsers.add(agent);
    }
  }

  void removeFromFavourites(String name) {
    favouriteUsers.removeWhere((a) => a['name'] == name);
  }
}
