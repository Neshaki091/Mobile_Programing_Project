import 'package:flutter/material.dart';
import '../data/models/workout_model.dart';
import '../data/repositories/workout_repository.dart';

class WorkoutProvider with ChangeNotifier {
  final WorkoutRepository _repository = WorkoutRepository();

  List<Workout> _workouts = []; // tất cả bài tập
  List<Workout> _favoriteWorkouts = []; // bài tập yêu thích
  List<Workout> _myWorkouts = []; // bài tập của tôi

  List<Workout> get workouts => _workouts;
  List<Workout> get favoriteWorkouts => _favoriteWorkouts;
  List<Workout> get myWorkouts => _myWorkouts;

  // Load tất cả bài tập
  Future<void> loadWorkouts() async {
    try {
      _workouts = await _repository.fetchWorkouts();
      notifyListeners();
    } catch (e) {
      print("Lỗi khi loadWorkouts: $e");
    }
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

  // Load bài tập yêu thích
  Future<void> loadFavorites() async {
    try {
      _favoriteWorkouts = await _repository.fetchFavorites();
      notifyListeners();
    } catch (e) {
      print("Lỗi khi loadFavorites: $e");
    }
  }

  // Thêm bài tập vào yêu thích
  Future<void> addToFavoriteWorkouts(Workout workout) async {
    if (_favoriteWorkouts.any((w) => w.name == workout.name)) return;
    await _repository.addToFavoriteWorkouts(workout);
    _favoriteWorkouts.add(workout);
    notifyListeners();
  }

  // Xóa bài tập khỏi yêu thích
  Future<void> removeFromFavoriteWorkouts(Workout workout) async {
    await _repository.removeFromFavoriteWorkouts(workout.name);
    _favoriteWorkouts.removeWhere((w) => w.name == workout.name);
    notifyListeners();
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

  bool isFavorite(Workout workout) {
    return _favoriteWorkouts.any((w) => w.id == workout.id);
  }
}
