import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Lấy người dùng hiện tại
  User? get currentUser => _firebaseAuth.currentUser;

  // Đăng nhập với email và mật khẩu
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // Xử lý lỗi
      return null;
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final result = await _firebaseAuth.signInWithCredential(credential);
    return result.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
