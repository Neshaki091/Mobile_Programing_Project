import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get firebaseUser => _user;

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Constructor: theo dõi thay đổi đăng nhập
  AuthViewModel() {
    _user = _auth.currentUser;
    if (_user != null) {
      _loadUserProfile(_user!.uid);
    }
    _auth.authStateChanges().listen((user) {
      _user = user;
      if (user != null) {
        _loadUserProfile(user.uid);
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }
  Future<void> initializeAuth() async {
    _user = _auth.currentUser;

    if (_user != null) {
      await _loadUserProfile(_user!.uid);
    } else {
      _userProfile = null;
    }

    notifyListeners();
  }

  /// Đăng ký
  Future<bool> signUp(String email, String password, String name) async {
    _setLoading(true);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;

      // Tạo user profile trong Firestore
      final newUser = UserProfile(
        uid: _user!.uid,
        name: name,
        email: email,
        avatarUrl: '', // hoặc 'admin' nếu là người quản trị
        height: 0, // Provide a default value or collect from user input
        weight: 0, // Provide a default value or collect from user input
        favorites:
            const [], // Provide a default value or collect from user input
        myWorkouts:
            const [], // Provide a default value or collect from user input
        friends: const [], // Provide a default value or collect from user input
      );

      await _firestore.collection('users').doc(_user!.uid).set(newUser.toMap());

      _userProfile = newUser;

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Đăng nhập
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;
      if (_user != null) {
        await _loadUserProfile(_user!.uid);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(e.message);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _userProfile = null;
    notifyListeners();
  }

  /// Lấy user profile từ Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
    } catch (e) {
      print('Lỗi khi lấy user profile: $e');
    }
    return null;
  }

  /// Cập nhật hồ sơ người dùng
  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedProfile.uid)
          .update(updatedProfile.toMap());
      if (_user?.uid == updatedProfile.uid) {
        _userProfile = updatedProfile;
        notifyListeners();
      }
    } catch (e) {
      _setError('Không thể cập nhật hồ sơ: $e');
    }
  }

  /// Tải hồ sơ người dùng hiện tại
  Future<void> _loadUserProfile(String uid) async {
    _userProfile = await getUserProfile(uid);
    notifyListeners();
  }

  /// Cờ đang tải
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Lỗi
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
