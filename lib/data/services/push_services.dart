// WARNING: using serverKey in client is insecure. See note below.
import 'dart:convert';

import 'package:http/http.dart' as http;

const String _FCM_SERVER_KEY = 'YOUR_FCM_SERVER_KEY';

Future<void> sendPushMessage({
  required String token,
  required String title,
  required String body,
}) async {
  try {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": token,
      "notification": {
        "title": title,
        "body": body,
        "sound": "default",
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done"
      }
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_FCM_SERVER_KEY',
    };

    final response = await http.post(
      Uri.parse(postUrl),
      body: jsonEncode(data),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('✅ Push sent successfully');
    } else {
      print('❌ Failed to send push: ${response.statusCode} ${response.body}');
    }
  } catch (e) {
    print("❌ sendPushMessage error: $e");
  }
}
