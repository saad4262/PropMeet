// file: presentation/views/user_side_views/notifications_view.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../../data/repositories/swipes_repository/swipes_repository.dart';

class NotificationsView extends StatelessWidget {
  final UserType userType; // pass agent/user
  const NotificationsView({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Scaffold(body: Center(child: Text("Not logged in")));

    final collectionName = userType == UserType.agent ? 'agentProfile' : 'profile_user';


    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collectionName)
            .doc(uid)
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications yet", style: TextStyle(fontSize: 12),));
          }

          final docs = snap.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final type = data['type'] ?? 'info';
              final fromName = (data['fromName'] != null && data['fromName'].toString().trim().isNotEmpty)
                  ? data['fromName']
                  : (data['fromEmail'] ?? 'Some User');

              final read = data['read'] ?? false;

              final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
              final formattedTime = createdAt != null
                  ? DateFormat('dd MMM yyyy, hh:mm a').format(createdAt)
                  : '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                color: read ? Colors.white : Colors.blue.withOpacity(0.07),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: type == 'match' ? Colors.pinkAccent : Colors.blueAccent,
                    child: Icon(
                      type == 'match' ? Icons.favorite : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    type == 'match'
                        ? "You matched with $fromName"
                        : (type == 'liked'
                        ? "$fromName liked you"
                        : "$type"),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                ),
                  subtitle: Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  onTap: () {
                    // Mark notification as read
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('notifications')
                        .doc(docs[i].id)
                        .update({'read': true});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
