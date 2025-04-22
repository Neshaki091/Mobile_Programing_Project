import 'package:flutter/material.dart';
import '../data/models/workout_model.dart';
import '../data/repositories/workout_repository.dart';

class WorkoutProvider with ChangeNotifier {
  final WorkoutRepository _repository = WorkoutRepository();

  List<Workout> _workouts = [];
  List<Workout> _favoriteWorkouts = [];
  List<Workout> _myWorkouts = [];

  List<Workout> get workouts => _workouts;
  List<Workout> get favoriteWorkouts => _favoriteWorkouts;
  List<Workout> get myWorkouts => _myWorkouts;

  // Load tất cả bài tập
  Future<void> loadWorkouts() async {
    _workouts = await _repository.fetchWorkouts();
    notifyListeners();
  }

  // Load bài tập cá nhân từ Firestore
  Future<void> loadMyWorkouts() async {
    try {
      _myWorkouts = await _repository.fetchMyWorkouts();
      notifyListeners();
    } catch (e) {
      print("Lỗi khi loadMyWorkouts: $e");
    }
  }

  // Thêm bài tập vào danh sách của tôi
  Future<void> addToMyWorkouts(Workout workout) async {
    if (_myWorkouts.any((w) => w.name == workout.name)) return;
    await _repository.addToMyWorkouts(workout);
    _myWorkouts.add(workout);
    notifyListeners();
  }

  // Xoá bài tập khỏi danh sách của tôi
  Future<void> removeFromMyWorkouts(Workout workout) async {
    await _repository.removeFromMyWorkouts(workout.name);
    _myWorkouts.removeWhere((w) => w.name == workout.name);
    notifyListeners();
  }
}
