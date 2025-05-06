import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Đăng ký với email và mật khẩu
  Future<User?> signUpWithEmail(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  // Đăng nhập với Google
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

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Lấy thông tin người dùng từ Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }

  // Lưu thông tin người dùng vào Firestore (bao gồm FCM Token)
  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  // Lưu FCM Token vào Firestore
  Future<void> saveFCMToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final token = await FirebaseMessaging.instance.getToken();
        print('FCM Token: $token');
        if (token != null) {
          final userRef = _firestore.collection('users').doc(user.uid);
          await userRef.set(
            {
              'fcmToken': token,
              'updatedAt':
                  FieldValue.serverTimestamp(), // Lưu thời gian cập nhật
            },
            SetOptions(merge: true),
          ); // Dùng merge để không ghi đè các dữ liệu khác
          print('FCM Token đã được lưu.');
        } else {
          print('Không thể lấy FCM token.');
        }
      } else {
        print('Người dùng chưa đăng nhập.');
      }
    } catch (e) {
      print("Lỗi khi lưu FCM Token: $e");
    }
  }

  // Xóa FCM Token khi người dùng đăng xuất
  // Xóa FCM Token khi người dùng đăng xuất
  Future<void> removeFCMToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final userRef = _firestore.collection('users').doc(user.uid);
        // Đặt FCM Token thành null
        await userRef.update({'fcmToken': null});
        print('FCM Token đã được đặt lại thành null.');
      }
    } catch (e) {
      print("Lỗi khi đặt lại FCM token: $e");
    }
  }
}
