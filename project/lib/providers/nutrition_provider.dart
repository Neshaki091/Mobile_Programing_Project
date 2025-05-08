// lib/providers/nutrition_provider.dart
import 'package:flutter/material.dart';
import '../data/repositories/nutrition_repository.dart';

class NutritionProvider with ChangeNotifier {
  final NutritionRepository _repository;

  List<Map<String, dynamic>> _nutritionData = [];
  bool _isLoading = false;
  String? _error;

  NutritionProvider(this._repository);

  List<Map<String, dynamic>> get nutritionData => _nutritionData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNutritionData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _repository.fetchNutritionData();
      _nutritionData = data;
    } catch (e) {
      _error = 'Lỗi khi tải dữ liệu';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
