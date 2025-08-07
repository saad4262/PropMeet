import 'package:get/get.dart';
import 'package:propmeet/core/network/network_checker.dart';

class NetworkUtils {
  static Future<bool> checkConnectionBeforeApiCall() async {
    final isConnected = await NetworkChecker.isConnected();
    if (!isConnected) {
      Get.snackbar(
        'No Internet Connection',
        'Please check your connection.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      return false;
    }
    return true;
  }
}


// import 'dart:io';

// class NetworkUtils {
//   static Future<bool> checkConnectionBeforeApiCall() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       return false;
//     }
//   }
// }
