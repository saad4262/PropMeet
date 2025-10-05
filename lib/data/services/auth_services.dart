  // import 'package:firebase_auth/firebase_auth.dart';
  // import 'package:cloud_firestore/cloud_firestore.dart';
  // import 'package:propmeet/model/authmodel/auth_model.dart';
  //
  // class FirebaseAuthService {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  //   Future<Auth?> signUp(String email, String password, {String tag = 'user'}) async {
  //     final userCred = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     final newUser = Auth(
  //       userId: userCred.user!.uid,
  //       email: email,
  //       tag: tag,
  //       createdAt: Timestamp.now(),
  //       updatedAt: Timestamp.now(),
  //     );
  //
  //     await _firestore
  //         .collection('users')
  //         .doc(newUser.userId)
  //         .set(newUser.toFirestore());
  //     return newUser;
  //   }
  //
  //   Future<Auth?> login(String email, String password) async {
  //     final userCred = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     final doc =
  //         await _firestore.collection('users').doc(userCred.user!.uid).get();
  //     return Auth.fromFirestore(doc);
  //   }
  //
  //   Future<void> logout() async {
  //     await _auth.signOut();
  //   }
  //
  //   Future<void> sendPasswordResetEmail(String email) async {
  //     await _auth.sendPasswordResetEmail(email: email);
  //   }
  // }

  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:propmeet/model/authmodel/auth_model.dart';

  class FirebaseAuthService {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // 🔔 Step 1 — Ask user for notification permission
    Future<void> requestNotificationPermission() async {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notifications allowed');
      } else {
        print('❌ Notifications not allowed');
      }
    }

    // 🔥 Step 2 — Save FCM token for the current user
    Future<void> saveUserToken(String uid) async {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      await _firestore.collection('users').doc(uid).set({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // If same user also exists as agent (optional)
      await _firestore.collection('agentProfile').doc(uid).set({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("💾 Token saved for user: $token");
    }

    // 👇 Updated Signup
    Future<Auth?> signUp(String email, String password, {String tag = 'user'}) async {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUser = Auth(
        userId: userCred.user!.uid,
        email: email,
        tag: tag,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await _firestore
          .collection('users')
          .doc(newUser.userId)
          .set(newUser.toFirestore());

      // ask permission + save FCM token
      await requestNotificationPermission();
      await saveUserToken(newUser.userId);

      return newUser;
    }

    // 👇 Updated Login
    Future<Auth?> login(String email, String password) async {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc =
      await _firestore.collection('users').doc(userCred.user!.uid).get();
      final authUser = Auth.fromFirestore(doc);

      // ask permission + update token
      await requestNotificationPermission();
      await saveUserToken(userCred.user!.uid);

      return authUser;
    }

    Future<void> logout() async {
      await _auth.signOut();
    }

    Future<void> sendPasswordResetEmail(String email) async {
      await _auth.sendPasswordResetEmail(email: email);
    }
  }

