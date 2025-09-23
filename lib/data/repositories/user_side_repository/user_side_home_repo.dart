
import '../../services/user_side_services/user_side_home_services.dart';

class UserRepository {
  final UserSideHomeServices _firebaseService = UserSideHomeServices();

  Future<void> addToFavourites(String userId, String agentId) {
    return _firebaseService.addFavourite(userId, agentId);
  }

  Future<void> removeFromFavourites(String userId, String agentId) {
    return _firebaseService.removeFavourite(userId, agentId);
  }

  Future<List<String>> fetchFavourites(String userId) {
    return _firebaseService.getFavourites(userId);
  }

  Future<void> likeAgent(String userId, String agentId) {
    return _firebaseService.addLike(userId, agentId);
  }

  Future<void> dislikeAgent(String userId, String agentId) {
    return _firebaseService.addDislike(userId, agentId);
  }
}
