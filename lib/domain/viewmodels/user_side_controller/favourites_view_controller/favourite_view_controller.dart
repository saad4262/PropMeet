import 'package:get/get.dart';

class FavouriteViewController extends GetxController{
  final RxList<Map<String, String>> favouriteAgents = <Map<String, String>>[].obs;

  void addToFavourites(Map<String, String> agent) {
    if (!favouriteAgents.any((a) => a['name'] == agent['name'])) {
      favouriteAgents.add(agent);
    }
  }

  void removeFromFavourites(String name) {
    favouriteAgents.removeWhere((a) => a['name'] == name);
  }
}