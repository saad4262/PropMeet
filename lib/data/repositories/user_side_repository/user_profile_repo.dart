import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/user_model/user_model.dart';

class UserProfileRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> fetchUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final userDoc = await _db.collection('users').doc(uid).get();
    final setupDoc = await _db
        .collection('users')
        .doc(uid)
        .collection('profile_user')
        .doc('setupData')
        .get();

    if (userDoc.exists && setupDoc.exists) {
      return UserModel.fromFirestore(userDoc.data()!, setupDoc.data()!);
    }
    return null;
  }

  Future<void> updateUserProfile(UserModel user) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection("users").doc(uid).set({
      "name": user.name,
      "email": user.email,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _db
        .collection("users")
        .doc(uid)
        .collection("profile_user")
        .doc("setupData")
        .set({
      "location": user.location,
      "progress": user.progress,
      "propertyDetails": user.propertyDetails.toMap(),
      "selections": user.selections,
    }, SetOptions(merge: true));
  }
}
