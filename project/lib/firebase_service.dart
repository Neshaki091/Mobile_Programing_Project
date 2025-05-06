import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Khởi tạo và xin quyền thông báo
  FirebaseService() {
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    try {
      await _firebaseMessaging.requestPermission(); // Quan trọng cho iOS
      print("📲 Notification permission granted.");
    } catch (e) {
      print("❌ Error requesting FCM permission: $e");
    }
  }

  // Đăng ký người dùng mới
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Lưu FCM token nhưng không chặn nếu lỗi
      _saveFCMToken(userCredential.user!).catchError((e) {
        print("❌ Error saving FCM token (signup): $e");
      });

      return userCredential.user;
    } catch (e) {
      print("❌ Sign up error: $e");
      throw e;
    }
  }

  // Đăng nhập người dùng
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      // Lưu FCM token nhưng không chặn nếu lỗi
      _saveFCMToken(userCredential.user!).catchError((e) {
        print("❌ Error saving FCM token (signin): $e");
      });

      return userCredential.user;
    } catch (e) {
      print("❌ Sign in error: $e");
      throw e;
    }
  }

  // Lưu FCM token vào Firestore
  Future<void> _saveFCMToken(User user) async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null && token.isNotEmpty) {
        await _firestore.collection('user_tokens').doc(user.uid).set({
          'token': token,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print("✅ FCM token saved: $token");
      } else {
        print("⚠️ FCM token is null or empty");
      }
    } catch (e) {
      print("❌ Error saving FCM token: $e");
    }
  }

  // Đăng nhập với Google
  Future<User?> signInWithGoogle() async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(),
      );

      _saveFCMToken(userCredential.user!).catchError((e) {
        print("❌ Error saving FCM token (Google): $e");
      });

      return userCredential.user;
    } catch (e) {
      print("❌ Google sign in error: $e");
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

  // Lấy danh sách sản phẩm từ Firestore
  Future<List<Map<String, String>>> getProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('DietarySupplementID')
              .doc('DSID')
              .collection('DSID')
              .get();

      List<Map<String, String>> products = [];
      for (var doc in querySnapshot.docs) {
        products.add({
          'name': doc['name'],
          'description': doc['descriptions'],
          'imageUrl': doc['imageURL'],
        });
      }

      return products;
    } catch (e) {
      print('❌ Error getting products: $e');
      throw e;
    }
  }

  // Lấy lịch trình của người dùng
  Future<Map<String, dynamic>> loadSchedule(String uid) async {
    try {
      final scheduleSnapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('schedule')
              .get();

      final schedule = <String, dynamic>{};
      for (var doc in scheduleSnapshot.docs) {
        schedule[doc.id] = doc.data();
      }

      return schedule;
    } catch (e) {
      print('❌ Error loading schedule: $e');
      throw e;
    }
  }

  // Lấy lịch trình tập luyện
  Future<Map<String, List<String>>> getSchedule(String uid) async {
    final doc = await _firestore.collection('workout_schedules').doc(uid).get();
    if (!doc.exists) return {};

    final data = doc.data()!;
    return data.map((key, value) => MapEntry(key, List<String>.from(value)));
  }

  // Lưu lịch trình tập luyện
  Future<void> saveSchedule(
    String uid,
    Map<String, List<String>> schedule,
  ) async {
    await _firestore.collection('workout_schedules').doc(uid).set(schedule);
  }
}
