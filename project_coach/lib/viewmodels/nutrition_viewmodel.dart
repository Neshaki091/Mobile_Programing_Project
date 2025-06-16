import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/nutrition_model.dart';

class NutritionViewModel extends ChangeNotifier {
  final CollectionReference _nutritionCollection =
      FirebaseFirestore.instance.collection('Nutritions');

  List<NutritionModel> _nutritionList = [];
  List<NutritionModel> get nutritionList => _nutritionList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Lấy danh sách thực phẩm
  Future<void> fetchNutritionData() async {
    _setLoading(true);
    try {
      QuerySnapshot snapshot = await _nutritionCollection.get();
      _nutritionList = [];

      for (var doc in snapshot.docs) {
        final raw = doc.data() as Map<String, dynamic>;
        if (raw.containsKey('Details')) {
          final jsonString = raw['Details'];
          try {
            final decoded = jsonDecode(jsonString);
            decoded['id'] = doc.id; // gắn id để cập nhật / xóa
            _nutritionList.add(NutritionModel.fromJson(decoded));
          } catch (e) {
            print('Lỗi decode JSON: $e');
          }
        }
      }

      _setLoading(false);
    } catch (e) {
      _setError("Lỗi khi lấy dữ liệu: $e");
    }
  }

  /// Thêm thực phẩm (dạng model)
  Future<void> addSingle(NutritionModel item) async {
    try {
      final jsonString = jsonEncode(item.toJson());
      await _nutritionCollection.add({'Details': jsonString});
      await fetchNutritionData();
    } catch (e) {
      _setError("Lỗi thêm: $e");
    }
  }

  /// Cập nhật thực phẩm (dạng model)
  Future<void> updateSingle(NutritionModel item) async {
    try {
      if (item.id == null) {
        _setError("Không tìm thấy ID để cập nhật");
        return;
      }

      final jsonString = jsonEncode(item.toJson());
      await _nutritionCollection.doc(item.id).update({'Details': jsonString});
      await fetchNutritionData();
    } catch (e) {
      _setError("Lỗi cập nhật: $e");
    }
  }

  /// Xóa thực phẩm theo model
  Future<void> deleteSingle(NutritionModel item) async {
    try {
      if (item.id == null) {
        _setError("Không tìm thấy ID để xóa");
        return;
      }

      await _nutritionCollection.doc(item.id).delete();
      await fetchNutritionData();
    } catch (e) {
      _setError("Lỗi xóa: $e");
    }
  }

  /// Gọi trong trường hợp dùng dữ liệu Map thay vì model (nếu cần)
  Future<void> addNutrition(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final jsonString = jsonEncode(data);
      await _nutritionCollection.add({'Details': jsonString});
      await fetchNutritionData();
    } catch (e) {
      _setError("Lỗi khi thêm: $e");
    }
  }

  Future<void> updateNutrition(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final jsonString = jsonEncode(data);
      await _nutritionCollection.doc(id).update({'Details': jsonString});
      await fetchNutritionData();
    } catch (e) {
      _setError("Lỗi khi cập nhật: $e");
    }
  }

  Future<void> deleteNutrition(String id) async {
    _setLoading(true);
    try {
      await _nutritionCollection.doc(id).delete();
      await fetchNutritionData();
    } catch (e) {
      _setError("Lỗi khi xóa: $e");
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }
}
