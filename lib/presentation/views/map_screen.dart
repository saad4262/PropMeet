import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/domain/viewmodels/auth_vm.dart';
import 'package:propmeet/domain/viewmodels/setupprofile_vm.dart';
import 'package:propmeet/shared/constants/app_colors.dart';
import 'package:propmeet/shared/utils/responsive_utils.dart';

class MapScreen extends StatelessWidget {
  // late  MapController controller = Get.put(MapController());
  final ProfileSetup controller = Get.put(ProfileSetup());

  late AuthController authController = Get.put(AuthController());

  MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQueryHelper(context);

    return Scaffold(
      body: Stack(
        children: [
          Obx(
                () => Container(
              key: ValueKey(
                controller.selectedLocation.value,
              ), // Forces UI rebuild

              child: GoogleMap(
                onMapCreated: controller.setMapController,
                initialCameraPosition: CameraPosition(
                  target:
                  controller.selectedLocation.value.latitude != 0.0
                      ? controller.selectedLocation.value
                      : const LatLng(24.8607, 67.0011), // Karachi default
                  zoom: 14,
                ),

                markers: controller.markers.toSet(),
              ),
            ),
          ),
          Obx(
                () =>
            controller.searchResults.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.only(
                top: 180.0,
                left: 15,
                right: 15,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    15,
                  ), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Soft shadow effect
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    15,
                  ), // Ensures content respects borders
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ), // Adds spacing inside
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final place = controller.searchResults[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              place.description,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              controller.selectPlace(place.placeId);
                            },
                          ),
                          if (index !=
                              controller.searchResults.length - 1)
                            Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ), // Separator
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
                : SizedBox.shrink(),
          ),
          Obx(() {
            final placeDetails = controller.selectedPlaceDetails.value;

            if (placeDetails == null) {
              // Show CircularProgressIndicator first
              return Center(
                child: CircularProgressIndicator(color: AppColors.blueMain),
              );
            }

            return Positioned(
              bottom: 100,
              left: 15,
              right: 15,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Details'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF234F68),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                            // child: Image.asset(ImageAssets.marker),
                            child: Icon(
                              Icons.location_on,
                              color: AppColors.blueMain,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              placeDetails.address,
                              style: TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Obx(
          //   () => controller.selectedPlaceDetails.value != null
          //       //     ? Align(
          //       //   alignment: Alignment.bottomCenter,
          //       //   child: Card(
          //       //     margin: EdgeInsets.all(10),
          //       //     child: Padding(
          //       //       padding: EdgeInsets.all(10),
          //       //       child: Column(
          //       //         mainAxisSize: MainAxisSize.min,
          //       //         children: [
          //       //           Text(
          //       //             "Name: ${controller.selectedPlaceDetails.value!.name}",
          //       //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       //           ),
          //       //           Text(
          //       //             "Address: ${controller.selectedPlaceDetails.value!.address}",
          //       //             style: TextStyle(fontSize: 14),
          //       //           ),
          //       //         ],
          //       //       ),
          //       //     ),
          //       //   ),
          //       // )
          //       ? Positioned(
          //           bottom: 120,
          //           left: 15,
          //           right: 15,
          //           child: Card(
          //             elevation: 5,
          //             child: Padding(
          //               padding: const EdgeInsets.all(16.0),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     ' Location Details',
          //                     style: const TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 18,
          //                         color: Color(0xFF234F68)),
          //                   ),
          //                   const SizedBox(height: 5),
          //                   Row(
          //                     children: [
          //                       Container(
          //                         height: 50,
          //                         child: Image.asset(ImageAssets.marker),
          //                       ),
          //                       const SizedBox(width: 10),
          //                       Expanded(
          //                         child: Text(
          //                           controller
          //                               .selectedPlaceDetails.value!.address,
          //                           style: TextStyle(fontSize: 14),
          //                           maxLines: 3,
          //                           overflow: TextOverflow.ellipsis,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         )
          //       // : Align(
          //       //     alignment: Alignment.bottomCenter,
          //       //     child: Card(
          //       //       margin: EdgeInsets.all(10),
          //       //       child: Padding(
          //       //         padding: EdgeInsets.all(10),
          //       //         child: Column(
          //       //           mainAxisSize: MainAxisSize.min,
          //       //           children: [
          //       //             Text(
          //       //               "Your Current Location",
          //       //               style: TextStyle(
          //       //                   fontSize: 16, fontWeight: FontWeight.bold),
          //       //             ),
          //       //             Text(
          //       //               "Lat: ${controller.selectedLocation.value.latitude}, Lng: ${controller.selectedLocation.value.longitude}",
          //       //               style: TextStyle(fontSize: 14),
          //       //             ),
          //       //           ],
          //       //         ),
          //       //       ),
          //       //     ),
          //       //   ),
          //   : CircularProgressIndicator(
          //
          //       color: AppColor.greenMain,
          //   )
          // ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 15),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFF5F4F8),
                  child: Icon(Icons.arrow_back_ios_new,color: Colors.black,),
                ),
              ),
            ),
          ),
          Positioned(
            top: 110,
            left: 15,
            right: 15,
            child: Padding(
              padding: const EdgeInsets.all(10),
              // child: TextField(
              //   onChanged: (query) => controller.searchPlaces(query),
              //   decoration: InputDecoration(
              //     hintText: "Search location",
              //     prefixIcon: Icon(Icons.search),
              //     suffixIcon: IconButton(
              //       icon: Icon(Icons.cancel),
              //       onPressed: () {
              //         controller.searchResults.clear();
              //       },
              //     ),
              //   ),
              // ),
              child: TextField(
                onChanged: (query) => controller.searchPlaces(query),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.settings_voice_rounded,
                    color: AppColors.blueMain,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.blueMain),
                  hintText: 'Find Location'.tr,
                  filled: true,
                  fillColor: Color(0xFFF5F4F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 50,
            child: CustomButton(
              text: "Choose your location".tr,
              isLoading: authController.isLoading.value,
              color: AppColors.blueMain,
              textColor: AppColors.white,
              borderRadius: 12,
              isFullWidth: false,
              height: Responsive.height(7),
              width: Responsive.width(70),
              onPressed: () {
                if (controller.selectedPlaceDetails.value != null) {
                  controller.selectPlace(
                    controller.selectedPlaceDetails.value!.name,
                  );

                  // Navigate after ensuring the location is set
                  Future.delayed(Duration(milliseconds: 200), () {
                    Get.back();
                  });
                } else {
                  Get.snackbar("Error", "Please select a location first!");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final IconData? icon;
  final bool isFullWidth;
  final bool isDisabled;
  final double? width;
  final double? height;

  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.icon,
    this.isFullWidth = false,
    this.isDisabled = false,
    this.width,
    this.height,
  });

  final ButtonController buttonController = Get.put(
    ButtonController(),
  ); // ✅ Initialize controller

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQueryHelper(context);

    return Obx(
          () => SizedBox(
        width:
        isFullWidth ? double.infinity : width ?? 200, // Default width: 200
        height: height ?? 50, // Default height: 50
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.zero,
            disabledBackgroundColor:
            color, // ✅ Prevents color from changing to grey when disabled
          ),

          onPressed:
          isDisabled || buttonController.isLoading.value
              ? null
              : () async {
            buttonController.startLoading();
            await Future.delayed(Duration(seconds: 2));
            buttonController.stopLoading();
            onPressed();
          },
          child:
          buttonController.isLoading.value
              ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: textColor,
              strokeWidth: 3,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 20),
                SizedBox(width: Responsive.width(.8)),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: Responsive.fontSize(4.5),
                  fontWeight: FontWeight.w600,
                  fontFamily: "poppins",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ButtonController extends GetxController {
  var isLoading = false.obs;

  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }
}