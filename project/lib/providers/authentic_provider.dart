import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticProvider with ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository();
  User? _user;

  AuthenticProvider() {
    initializeAuth(); // Gọi phương thức initializeAuth khi bắt đầu ứng dụng
  }

  User? get user => _user;
  AuthRepository get authRepo => _authRepo; // ✅ expose authRepo

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
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      _user = await _authRepo.signUpWithEmail(email, password);
      notifyListeners();
      return _user != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      _user = await _authRepo.signInWithGoogle();
      notifyListeners();
      return _user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    // Xoá lịch tập local khi đăng xuất
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('workout_schedule');

    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  bool get isLoggedIn => _user != null;
}
