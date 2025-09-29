import 'package:propmeet/data/services/agent_side_services/agent_side_home_services.dart';

class AgentSideHomeRepo{
  final AgentSideHomeServices _firebaseService = AgentSideHomeServices();

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