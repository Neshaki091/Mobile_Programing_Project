import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();


  User? _user;

  User? get user => _user;

  // Kiểm tra trạng thái đăng nhập
  void checkLoginStatus() {
    _user = _authRepository.getUser();
    notifyListeners();
  }

  // Đăng nhập
  Future<bool> login(String email, String password) async {
    User? user = await _authRepository.login(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginWithGoogle() async {
    User? user = await _authRepository.loginWithGoogle();
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Đăng ký
  Future<bool> register(String email, String password) async {
    User? user = await _authRepository.register(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Đăng xuất
  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }
}
