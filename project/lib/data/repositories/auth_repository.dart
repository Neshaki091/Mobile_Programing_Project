import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_service.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<User?> login(String email, String password) async {
    return await _firebaseService.signInWithEmail(email, password);
  }

  Future<User?> register(String email, String password) async {
    return await _firebaseService.signUpWithEmail(email, password);
  }

  Future<User?> loginWithGoogle() async {
    return await _firebaseService.loginWithGoogle();
  }

  Future<void> logout() async {
    await _firebaseService.signOut();
  }

  User? getUser() {
    return _firebaseService.getCurrentUser();
  }
}
