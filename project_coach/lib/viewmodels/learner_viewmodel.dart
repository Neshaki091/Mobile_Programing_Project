import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/learner_services.dart';

class LearnerViewModel extends ChangeNotifier {
  final LearnerService _service = LearnerService();

  List<UserProfile> _learners = [];
  List<UserProfile> get learners => _learners;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadLearners() async {
    _isLoading = true;
    notifyListeners();

    _learners = await _service.fetchAllUsers();

    _isLoading = false;
    notifyListeners();
  }
}
