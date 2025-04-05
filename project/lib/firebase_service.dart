// lib/data/firebase_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký người dùng mới
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng nhập người dùng
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng nhập với Google
  Future<User?> signInWithGoogle() async {
    // Bạn sẽ cần cài đặt Google Sign-In cho Firebase ở đây
    // Đoạn này sử dụng thư viện 'google_sign_in' và 'firebase_auth'
    try {
      // Giả sử đăng nhập Google thành công, trả về user
      final UserCredential userCredential = await _auth.signInWithCredential(GoogleAuthProvider.credential());
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
