import 'package:cloud_firestore/cloud_firestore.dart';

class SwipesRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> recordSwipe({
    required String swiperId,
    required String targetId,
  }) async {
    final swiperRef = _db.collection('swipes').doc(swiperId);
    final targetRef = _db.collection('swipes').doc(targetId);

    // Add target to liked list
    await swiperRef.set({
      'liked': FieldValue.arrayUnion([targetId]),
    }, SetOptions(merge: true));

    // Check if mutual like exists
    final targetSnap = await targetRef.get();
    final targetLikes = (targetSnap.data()?['liked'] as List?) ?? [];

    if (targetLikes.contains(swiperId)) {
      await _saveMatch(swiperId, targetId);
    }
  }

  Future<void> _saveMatch(String userA, String userB) async {
    final refA = _db.collection('swipes').doc(userA);
    final refB = _db.collection('swipes').doc(userB);

    await refA.set({'matched': FieldValue.arrayUnion([userB])}, SetOptions(merge: true));
    await refB.set({'matched': FieldValue.arrayUnion([userA])}, SetOptions(merge: true));

    // Create match notifications for both sides
    await _db.collection('users').doc(userA).collection('notifications').add({
      'fromId': userB,
      'type': 'match',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('users').doc(userB).collection('notifications').add({
      'fromId': userA,
      'type': 'match',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
