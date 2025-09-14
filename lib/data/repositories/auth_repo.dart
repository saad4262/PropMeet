import 'package:propmeet/data/services/auth_services.dart';
import 'package:propmeet/model/authmodel/auth_model.dart';

class AuthRepository {
  final FirebaseAuthService _service = FirebaseAuthService();

  AuthRepository();

  Future<Auth?> signUp(String email, String password) async {
    return _service.signUp(email, password);
  }

  Future<Auth?> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<void> logout() async {
    await _service.logout();
  }

  Future<void> resetPassword(String email) {
    return _service.sendPasswordResetEmail(email);
  }
}
