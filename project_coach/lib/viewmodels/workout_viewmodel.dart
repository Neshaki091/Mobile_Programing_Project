import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../services/firebase_services.dart';

class WorkoutViewModel extends ChangeNotifier {
  List<WorkoutModel> _myWorkouts = [];
  List<WorkoutModel> get myWorkouts => _myWorkouts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Lấy danh sách bài tập của HLV hiện tại
  Future<void> fetchWorkouts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = FirebaseService.currentUserId();
      _myWorkouts = await FirebaseService.getWorkouts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Lỗi khi tải bài tập: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Xóa bài tập
  Future<void> deleteWorkout(String id) async {
    try {
      await FirebaseService.deleteWorkout(id);
    } catch (e) {
      _errorMessage = 'Lỗi khi xóa bài tập: ${e.toString()}';
      notifyListeners();
    }
  }
}
