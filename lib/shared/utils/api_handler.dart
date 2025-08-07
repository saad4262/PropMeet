import 'package:get/get.dart';
import 'network_utils.dart';
import 'dart:io';
import 'dart:async';

class ApiHandler {
  static Future<T?> safeApiCall<T>(Future<T> Function() apiFunction) async {
    final isOnline = await NetworkUtils.checkConnectionBeforeApiCall();
    if (!isOnline) return null;

    try {
      return await apiFunction();
    } on SocketException {
      Get.snackbar('Network Error', 'No Internet Connection.');
    } on HttpException {
      Get.snackbar('Server Error', 'Something went wrong with the server.');
    } on FormatException {
      Get.snackbar('Data Error', 'Bad response format.');
    } on TimeoutException {
      Get.snackbar('Timeout', 'Request timed out.');
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error: $e');
    }

    return null;
  }
}
