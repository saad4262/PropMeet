import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:propmeet/domain/viewmodels/agent_side_controller/agent_profile_view_controller/agent_edit_profile_view_controller.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';
import '../../../../domain/viewmodels/agent_side_controller/agent_profile_view_controller/agent_profile_view_controller.dart';
import '../../../widgets/custom_button.dart';

class AgentEditProfileView extends StatelessWidget {
  AgentEditProfileView({super.key});

  final AgentEditProfileViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agent Profile",
          style: TextStyle(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final agent = controller.agent.value;
        if (agent == null) {
          return Center(
            child: Text(
              "No profile found",
              style: TextStyle(fontSize: Responsive.fontSize(4)),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.padding(6),
                    vertical: Responsive.padding(2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(agent.profileImage),
                          radius: 28,
                        ),
                        title: Column(
                          children: [
                            Text(
                              "${agent.firstName} ${agent.lastName}",
                              style: TextStyle(
                                fontSize: Responsive.fontSize(4),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              agent.professionalTitle,
                              style: TextStyle(
                                fontSize: Responsive.fontSize(4),
                              ),
                            ),
                            SizedBox(height: Responsive.height(1)),
                            CustomButton(
                              width: 150,
                              height: 40,
                              text: "Edit Profile",
                              icon: Icons.edit,
                              onPressed: () {},
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        dense: true,
                      ),

                      Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        agent.bio ?? "--",
                        style: TextStyle(fontSize: Responsive.fontSize(4)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),


              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Experience & Rating",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              _infoItem("Service", agent.serviceProvided),
                              _infoItem("Experience", "${agent.yearsOfExperience} Years"?? "--"),
                            ],
                          ),
                          TableRow(
                            children: [
                              _infoItem("Reviews", agent.clientReviews),
                              _infoItem("Rating", agent.averageRating),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sales History",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            _infoItem("House", agent.house),
                            _infoItem("Townhouse", agent.townhouse),
                          ]),
                          TableRow(children: [
                            _infoItem("Apartment", agent.apartmentAndUnit),
                            _infoItem("Land", agent.land),
                          ]),
                          TableRow(children: [
                            _infoItem("Luxury Homes", agent.luxuryHomes),
                            _infoItem("Rural/Acreage", agent.ruralAcreage),
                          ]),
                          TableRow(children: [
                            _infoItem("Off the Plan", agent.offThePlan),
                            _infoItem("Sold Properties", agent.soldProperties),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Performance History",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            _infoItem("Median Days on Market", agent.medianDaysOnMarket),
                            _infoItem("Currently Managing", agent.managedProperties),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fee Details",
                        style: TextStyle(
                          fontSize: Responsive.fontSize(4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            _infoItem("Fee Structure", agent.feeStructure),
                            _infoItem("Fees Negotiable", agent.feesNegotiable),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

            ],
          ),
        );
      }),
    );
  }

  Widget _infoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Responsive.fontSize(3.5),
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.fontSize(4),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
