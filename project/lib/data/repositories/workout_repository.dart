import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get uid => _auth.currentUser?.uid;

  // Lấy tất cả bài tập từ collection "workout"
  Future<List<Workout>> fetchWorkouts() async {
    final snapshot = await _firestore.collection('workout').get();
    return snapshot.docs
        .map((doc) => Workout.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Lấy danh sách bài tập của tôi
  Future<List<Workout>> fetchMyWorkouts() async {
    if (uid == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('my_workouts')
            .get();

    return snapshot.docs
        .map((doc) => Workout.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Lấy danh sách bài tập yêu thích
  Future<List<Workout>> fetchFavorites() async {
    if (uid == null) return [];

    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('favorites')
            .get();

    return snapshot.docs
        .map((doc) => Workout.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Thêm bài tập vào danh sách yêu thích
  Future<void> addToFavoriteWorkouts(Workout workout) async {
    if (uid == null) return;

    // Dùng workout.name làm documentId để không bị trùng
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(workout.name) // dùng tên bài tập làm id
        .set(workout.toMap());
  }

  // Xóa bài tập khỏi danh sách yêu thích
  Future<void> removeFromFavoriteWorkouts(String workoutName) async {
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(workoutName)
        .delete();
  }

  // Thêm bài tập vào danh sách của tôi
  Future<void> addToMyWorkouts(Workout workout) async {
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('my_workouts')
        .doc(workout.name) // cũng dùng tên bài tập làm id
        .set(workout.toMap());
  }

  // Xóa bài tập khỏi danh sách của tôi
  Future<void> removeFromMyWorkouts(String workoutName) async {
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('my_workouts')
        .doc(workoutName)
        .delete();
  }
}
