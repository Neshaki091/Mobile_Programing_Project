import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_model.dart';

class WorkoutRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách bài tập từ Firestore (collection 'workouts')
  Future<List<Workout>> fetchWorkouts() async {
    final snapshot = await _firestore.collection('workout').get();
    return snapshot.docs
        .map((doc) => Workout.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Lấy bài tập của người dùng từ Firestore
  Future<List<Workout>> fetchMyWorkouts() async {
    final uid = _auth.currentUser?.uid;
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

  // Thêm bài tập vào Firestore (my_workouts)
  Future<void> addToMyWorkouts(Workout workout) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('my_workouts')
        .add(workout.toMap());
  }

  // Xóa bài tập khỏi Firestore (my_workouts)
  Future<void> removeFromMyWorkouts(String workoutName) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final query =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('my_workouts')
            .where('name', isEqualTo: workoutName)
            .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }
}
