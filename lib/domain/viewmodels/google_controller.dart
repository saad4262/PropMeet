import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propmeet/core/routes/app_routes.dart';
import 'package:propmeet/data/repositories/google_repo.dart';
import 'package:propmeet/model/authmodel/auth_model.dart';


class GoogleAuthController extends GetxController {
  final GoogleAuthRepository _repository = GoogleAuthRepository();

  var isLoading = false.obs;
  var user = Rxn<Auth>();

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final result = await _repository.signInWithGoogle();

      if (result != null) {
        user.value = result;

        // ✅ Firestore check
        final userDoc = await FirebaseFirestore.instance
            .collection("users")
            .doc(result.userId)
            .get();

        if (!userDoc.exists) {
          // 🔥 First time signup → Firestore pe doc create karo
          await FirebaseFirestore.instance.collection("users").doc(result.userId).set({
            "uid": result.userId,
            "name": result.displayName,
            "email": result.email,
            "photoUrl": result.avatarUrl,
            "tag": result.tag ?? "user", // default user
            "createdAt": DateTime.now(),
          });

          // Pehli dafa signup → setup screen
          if ((result.tag ?? "user") == "user") {
            Get.offAll(() => AppRoutes.setupProfile);
          } else {
            Get.offAll(() => AppRoutes.setupAgent);
          }
        } else {
          // ✅ Returning user
          final tag = userDoc['tag'];

          // if (tag == "user") {
          //   Get.offAll(() => UserHomeView());
          // } else {
          //   Get.offAll(() => AgentHomeView());
          // }
        }
      } else {
        Get.snackbar("Error", "Google Sign-In failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    user.value = null;
    Get.snackbar("Signed Out", "You have been logged out");
  }
}
