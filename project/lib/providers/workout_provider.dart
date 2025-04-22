import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/models/workout_model.dart';
import '../data/repositories/workout_repository.dart';
class WorkoutProvider with ChangeNotifier {
  final WorkoutRepository _repository = WorkoutRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Workout> _workouts = [];
  List<Workout> _favoriteWorkouts = [];
  List<Workout> _myWorkouts = [];

  // Getters
  List<Workout> get workouts => _workouts;
  List<Workout> get favoriteWorkouts => _favoriteWorkouts;
  List<Workout> get myWorkouts => _myWorkouts;

  // Load all workouts
  Future<void> loadWorkouts() async {
    _workouts = await _repository.fetchWorkouts();
    notifyListeners();
  }

  // Tải bài tập của người dùng từ Firestore
  Future<void> loadMyWorkouts() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('my_workouts')
            .get();
    _myWorkouts =
        snapshot.docs
            .map((doc) => Workout.fromMap(doc.data(), doc.id))
            .toList();
    notifyListeners();
  }

  // Thêm vào bài tập của tôi
  Future<void> addToMyWorkouts(Workout workout) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Kiểm tra trùng
    if (myWorkouts.any((w) => w.name == workout.name)) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('my_workouts')
        .add(workout.toMap());
    myWorkouts.add(workout);
    notifyListeners();
  }

  // Xóa bài tập khỏi danh sách của tôi
  Future<void> removeFromMyWorkouts(Workout workout) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final query =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('my_workouts')
            .where('name', isEqualTo: workout.name)
            .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }

    myWorkouts.removeWhere((w) => w.name == workout.name);
    notifyListeners();
  }
}
