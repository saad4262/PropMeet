import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:propmeet/shared/config/app_assets/app_assets.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/constants/app_images.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

import '../../../../domain/viewmodels/user_side_controller/chat_view_controller/chat_view_controller.dart';

class ChatView extends StatelessWidget {
  final String? name;
  final String? image;
  final ChatViewController controller = Get.find();

  ChatView({super.key,this.name,  this.image});

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    image ?? AppAssets.favouriteIcon,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: Responsive.width(2)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? "dlw",
                  style: TextStyle(
                    fontSize: Responsive.fontSize(5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Icon(Icons.call),
          SvgPicture.asset(
           AppAssets.audioCallIcon,
            width: 25,
            height: 25,
            color: Color(0xff606060),
          ),
          SizedBox(width: 15),
          SvgPicture.asset(
            //AppImages.chatcall,
            AppAssets.videoCallIcon,
            width: 25,
            height: 25,
            color: Color(0xff606060),
          ),
          SizedBox(width: 15),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Color(0xff606060)),
            offset: Offset(0, 55),

            onSelected: (value) {
              if (value == 'block') {
                // Call your block user function
                print("User blocked");
                // Example: controller.blockUser(name);
              } else if (value == 'delete') {
                // Call your delete chat function
                print("Chat deleted");
                // Example: controller.deleteChat(name);
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'block',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Block User'),
                        SizedBox(width: Responsive.width(2)),
                        Icon(Icons.block, size: 16),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delete Chat'),
                        SizedBox(width: Responsive.width(2)),
                        Icon(Icons.delete, size: 16),
                      ],
                    ),
                  ),
                ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Container(height: Responsive.height(.5), color: Color(0xffC7BA00)),
          // Messages
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  bool isMe = controller.messages[index]["isMe"] as bool;

                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        // max width 90% of screen
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isMe ? Color(0xff9BBAFF) : Color(0xFFDDDFE5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Message Text
                            Text(
                              controller.messages[index]["text"] as String,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(4),
                                color: Colors.black87,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 5),

                            // Time + Check
                            Row(
                              mainAxisSize:
                                  MainAxisSize.min, // shrink to content
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  controller.messages[index]["time"] as String,
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(3),
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(width: 5),
                                if (isMe)
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Message Input
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade600),
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            print("Emoji / Attachment tapped");
                          },
                          child: Icon(
                            Icons.attach_file,
                            size: 25,
                            color: Color(0xff606060),
                          ),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                        ), // adjust for icon
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    controller.sendMessage(textController.text);
                    textController.clear();
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xff3236D3),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
