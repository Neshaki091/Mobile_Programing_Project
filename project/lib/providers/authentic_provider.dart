import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/auth_repository.dart';

class AuthenticProvider with ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  User? _user;

  AuthenticProvider() {
    initializeAuth(); // Gọi phương thức initializeAuth khi bắt đầu ứng dụng
  }

  User? get user => _user;

  Future<void> initializeAuth() async {
    _user = _authRepo.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    try {
      _user = await _authRepo.signInWithEmail(email, password);
      notifyListeners();
      return _user != null;
    } catch (e) {
      // Xử lý lỗi và trả về false nếu không thành công
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      _user = await _authRepo.signUpWithEmail(email, password);
      notifyListeners();
      return _user != null;
    } catch (e) {
      // Xử lý lỗi và trả về false nếu không thành công
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      _user = await _authRepo.signInWithGoogle();
      notifyListeners();
      return _user != null;
    } catch (e) {
      // Xử lý lỗi và trả về false nếu không thành công
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepo.signOut();
    _user = null;
    notifyListeners();
  }

  bool get isLoggedIn => _user != null;
}
