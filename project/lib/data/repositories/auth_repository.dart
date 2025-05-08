import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // ✅ Thêm dòng này

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy người dùng hiện tại
  User? get currentUser => _firebaseAuth.currentUser;

  // Lấy FCM token
  Future<String?> _getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  // Cập nhật FCM token khi người dùng đăng nhập
  Future<void> updateFcmToken(String uid) async {
    final token = await _getFcmToken();
    if (token != null) {
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
    }
  }

  // Đăng nhập bằng email
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user != null) {
        await updateFcmToken(user.uid); // ✅ Lưu FCM token sau khi đăng nhập
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  // Đăng ký bằng email
  Future<User?> signUpWithEmail(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    if (user != null) {
      await updateFcmToken(user.uid);
    }
    return user;
  }

  // Đăng nhập bằng Google
  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final result = await _firebaseAuth.signInWithCredential(credential);
    final user = result.user;
    if (user != null) {
      await updateFcmToken(user.uid);
    }
    return user;
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Lấy hồ sơ người dùng
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }

  // Cập nhật hồ sơ người dùng
  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }
}
