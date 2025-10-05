import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/viewmodels/user_side_controller/home_controller/notification_controller.dart';

class NotificationView extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Likes"),
              Tab(text: "Matches"),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.notifications.isEmpty) {
            return Center(child: Text("No notifications yet", style: TextStyle(fontSize: 12),));
          }

          final likes = controller.notifications
              .where((n) => n['type'] == 'like')
              .toList();
          final matches = controller.notifications
              .where((n) => n['type'] == 'match')
              .toList();

          return TabBarView(
            children: [
              buildList(likes, "❤️"),
              buildList(matches, "🎉"),
            ],
          );
        }),
      ),
    );
  }

  Widget buildList(List notifs, String icon) {
    if (notifs.isEmpty) {
      return Center(child: Text("No $icon notifications"));
    }
    return ListView.builder(
      itemCount: notifs.length,
      itemBuilder: (context, index) {
        final notif = notifs[index];
        final email = notif['fromUserEmail'] ?? 'Unknown';
        final createdAt = notif['createdAt'] != null
            ? notif['createdAt'].toDate().toString()
            : "";

        return ListTile(
          leading: CircleAvatar(child: Text(icon)),
          title: Text(email),
          subtitle: Text(createdAt, style: TextStyle(fontSize: 10)),
        );
      },
    );
  }
}
