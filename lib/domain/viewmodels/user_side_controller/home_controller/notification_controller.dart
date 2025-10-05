import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = [].obs;
  var isLoading = false.obs;

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    _listenToNotifications();
  }

  void _listenToNotifications() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _sub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snap) {
      notifications.value = snap.docs.map((d) => d.data()).toList();
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
