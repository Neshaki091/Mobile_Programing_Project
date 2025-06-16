import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_coach/models/workout_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String currentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  // Đăng ký người dùng mới
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng nhập người dùng
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng nhập với Google (giả định đang dùng GoogleAuthProvider.credential sẵn)
  Future<User?> signInWithGoogle() async {
    try {
      final UserCredential userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(),
      );
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lấy người dùng hiện tại
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
          'name': doc['name'] ?? '',
          'description': doc['descriptions'] ?? '',
          'imageUrl': doc['imageURL'] ?? '',
        });
      }

      return products;
    } catch (e) {
      print('Error loading products: $e');
      throw e;
    }
  }

  // ------------------ WORKOUT ------------------
  static Future<List<WorkoutModel>> getWorkoutsByUser(String userId) async {
    final snapshot =
        await _firestore
            .collection('workout')
            .where('ownerId', isEqualTo: userId)
            .get();

    return snapshot.docs
        .map((doc) => WorkoutModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Thêm bài tập mới
  static Future<void> addWorkout(WorkoutModel workout) async {
    final docRef = _firestore.collection('workout').doc(); // random ID
    await docRef.set(workout.copyWith(id: docRef.id).toMap());
  }

  /// Cập nhật bài tập
  static Future<void> updateWorkout(WorkoutModel workout) async {
    await _firestore
        .collection('workout')
        .doc(workout.id)
        .update(workout.toMap());
  }

  /// Xóa bài tập
  static Future<void> deleteWorkout(String id) async {
    await _firestore.collection('workout').doc(id).delete();
  }

  /// Lấy danh sách bài tập
  static Future<List<WorkoutModel>> getWorkouts() async {
    final snapshot = await _firestore.collection('workout').get();
    return snapshot.docs
        .map((doc) => WorkoutModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}
