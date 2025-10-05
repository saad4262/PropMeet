import 'package:get/get.dart';

class AgentChatViewController extends GetxController{
  // Dummy chats list
  var chats =
      [
        {
          "name": "John",
          "message": "Here is the message",
          "image": "https://i.pravatar.cc/150?img=1",
        },
        {
          "name": "Alice",
          "message": "Hey there! How are you?",
          "image": "https://i.pravatar.cc/150?img=2",
        },
        {
          "name": "Emma",
          "message": "Let’s catch up tomorrow!",
          "image": "https://i.pravatar.cc/150?img=3",
        },
        {
          "name": "Michael",
          "message": "Did you see the news today?",
          "image": "https://i.pravatar.cc/150?img=4",
        },
        {
          "name": "Sophia",
          "message": "I'll call you in 10 mins.",
          "image": "https://i.pravatar.cc/150?img=5",
        },
        {
          "name": "Liam",
          "message": "Meeting is rescheduled to 3 PM.",
          "image": "https://i.pravatar.cc/150?img=6",
        },
        {
          "name": "Olivia",
          "message": "Thanks for your help!",
          "image": "https://i.pravatar.cc/150?img=7",
        },
        {
          "name": "Noah",
          "message": "Can you share the file?",
          "image": "https://i.pravatar.cc/150?img=8",
        },
      ].obs;

  // Dummy messages (single chat)
  var messages =
      [
        {"isMe": false, "text": "Hello!", "time": "19:55"},
        {"isMe": true, "text": "Hi John, how are you?", "time": "19:56"},
        {"isMe": false, "text": "I am good, thanks!", "time": "19:57"},
        {"isMe": true, "text": "Great 👍", "time": "19:58"},
      ].obs;

  // Add new message
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add({"isMe": true, "text": text, "time": "20:00"});
  }
}