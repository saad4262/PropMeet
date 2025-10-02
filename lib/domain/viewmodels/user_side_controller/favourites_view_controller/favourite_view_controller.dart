// import 'package:get/get.dart';
//
// class FavouriteViewController extends GetxController{
//   final RxList<Map<String, String>> favouriteAgents = <Map<String, String>>[].obs;
//
//   void addToFavourites(Map<String, String> agent) {
//     if (!favouriteAgents.any((a) => a['name'] == agent['name'])) {
//       favouriteAgents.add(agent);
//     }
//   }
//
//   void removeFromFavourites(String name) {
//     favouriteAgents.removeWhere((a) => a['name'] == name);
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/user_side_repository/user_side_home_repo.dart';

class FavouriteViewController extends GetxController {
  final RxList<Map<String, String>> favouriteAgents = <Map<String, String>>[].obs;
  final UserRepository _repo = UserRepository();


  final String userId = FirebaseAuth.instance.currentUser!.uid;

  void addToFavourites(Map<String, String> agent) async {
    // local update
    if (!favouriteAgents.any((a) => a['name'] == agent['name'])) {
      favouriteAgents.add(agent);
    }

    // Firestore update
    await _repo.addToFavourites(userId, agent["id"] ?? agent["name"]!);
  }

  void removeFromFavourites(String name, String agentId) async {
    favouriteAgents.removeWhere((a) => a['name'] == name);
    await _repo.removeFromFavourites(userId, agentId);
  }


  Future<void> loadFavourites() async {
    final favIds = await _repo.fetchFavourites(userId);
    // here you need to map favIds → agent details (fetch from agents collection maybe?)
    // For now just print:
    print("User favourites from Firestore: $favIds");
  }
}
