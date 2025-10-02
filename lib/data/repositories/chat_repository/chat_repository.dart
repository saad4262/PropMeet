import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _chatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode
        ? "${uid1}_$uid2"
        : "${uid2}_$uid1";
  }

  Future<String> createChatIfMatch(
      BuildContext context, String userA, String userB) async {
    final chatId = _chatId(userA, userB);

    final chatRef = _db.collection("chats").doc(chatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        "members": [userA, userB],
        "createdAt": FieldValue.serverTimestamp(),
      });

      // auto system msg
      await chatRef.collection("messages").add({
        "senderId": "system",
        "text": "🎉 It’s a match! Start chatting now.",
        "createdAt": FieldValue.serverTimestamp(),
      });

      // 👇 instead of FCM, just local push (snackbar)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 It's a match! Chat created."),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    return chatId;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessages(String chatId) {
    return _db
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String chatId, String text) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection("chats").doc(chatId).collection("messages").add({
      "senderId": uid,
      "text": text,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
