import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:propmeet/model/authmodel/auth_model.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Auth?> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In
      await _googleSignIn.initialize();

      // Prompt user to pick a Google account
      final googleUser = await _googleSignIn.authenticate();
      // if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      final docRef = _firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        // Create Firestore record for new user
        final newUser = Auth(
          userId: user.uid,
          displayName: user.displayName ?? '',
          email: user.email ?? '',
          avatarUrl: user.photoURL ?? '',
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );
        await docRef.set(newUser.toFirestore());
        return newUser;
      } else {
        return Auth.fromFirestore(doc);
      }
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
