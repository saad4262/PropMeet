import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/presentation/widgets/custom_user_appBar.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';
import '../../../../domain/viewmodels/user_side_controller/chat_view_controller/chat_view_controller.dart';
import 'chat_view.dart';


class ChatListScreen extends StatelessWidget {
  final ChatViewController controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomUserAppbar(title: 'App Name'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: Responsive.height(.5), color: Color(0xffC7BA00)),

          // Matches Section
          Padding(
            padding: EdgeInsets.all(Responsive.padding(4)),
            child: Text(
              "Matches",
              style: TextStyle(
                fontSize: Responsive.fontSize(5),
                fontWeight: FontWeight.bold,
                fontFamily: "poppins",
                color: AppColors.blueMain,
              ),
            ),
          ),
          SizedBox(
            height: Responsive.height(25),
            child: Obx(
                  () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.chats.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.width(2),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(30),
                          height: Responsive.height(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(
                                controller.chats[index]["image"]!,
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.3,
                                ), // shadow color
                                spreadRadius: 2, // how much the shadow spreads
                                blurRadius: 5, // softness of the shadow
                                offset: Offset(
                                  0,
                                  3,
                                ), // x, y offset (0 horizontal, 3 downwards)
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: Responsive.height(1)),
                        Text(
                          controller.chats[index]["name"]!,
                          style: TextStyle(
                            fontSize: Responsive.height(
                              2,
                            ), // or Responsive.fontSize(4)
                            fontFamily: "poppins",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Messages Section
          Padding(
            padding: EdgeInsets.all(Responsive.padding(4)),
            child: Text(
              "Messages",
              style: TextStyle(
                fontSize: Responsive.fontSize(5),
                fontWeight: FontWeight.bold,
                fontFamily: "poppins",
                color: AppColors.blueMain,
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () => ListView.separated(
                itemCount: controller.chats.length,
                separatorBuilder:
                    (context, index) => Divider(
                  color: Colors.grey[300],
                  thickness: 1, // thickness of divider
                  indent: 0, // start from left edge
                  endIndent: 0, // go to right edge
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            controller.chats[index]["image"]!,
                          ),
                          radius: 35,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      controller.chats[index]["name"]!,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(4),
                        fontWeight: FontWeight.bold,
                        fontFamily: "poppins",
                      ),
                    ),
                    subtitle: Text(
                      controller.chats[index]["message"]!,
                      style: TextStyle(
                        fontSize: Responsive.fontSize(4),
                        fontFamily: "poppins",
                        color: Color.fromARGB(255, 120, 120, 120),
                      ),
                    ),
                    onTap: () {
                      Get.to(
                            () => ChatView(
                          name: controller.chats[index]["name"]!,
                          image: controller.chats[index]["image"]!,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}