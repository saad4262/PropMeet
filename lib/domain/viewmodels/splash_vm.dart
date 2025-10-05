// import 'package:get/get.dart';
// import 'package:propmeet/core/routes/app_routes.dart';

// class SplashController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     Future.delayed(const Duration(seconds: 3), () {
//       Get.offNamed(AppRoutes.onBoarding);
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:propmeet/core/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3)); // show splash 3 sec

    final auth = FirebaseAuth.instance;
    await auth.currentUser?.reload(); // ✅ refresh the session
    final user = auth.currentUser;

    if (user == null) {
      // ❌ User not logged in → go to onboarding
      Get.offAllNamed(AppRoutes.onBoarding);
    } else {
      // ✅ User logged in → check role from Firestore
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (snapshot.exists) {
        final role = snapshot['tag'] ?? 'user';
        if (role == 'agent') {
          Get.offAllNamed(AppRoutes.agentBottomBarView);
        } else {
          Get.offAllNamed(AppRoutes.bottomBarView);
        }
      } else {
        // fallback agar doc na mile
        Get.offAllNamed(AppRoutes.onBoarding);
      }
    }
  }
}
