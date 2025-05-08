import 'package:flutter/material.dart';
import 'package:project/data/repositories/journey_repository.dart';
import 'package:project/data/models/body_measurement.dart';

class BodyMeasurementProvider with ChangeNotifier {
  final BodyMeasurementRepository _repository;
  List<BodyMeasurement> _bodyMeasurements = [];
  bool _isLoading = false;

  List<BodyMeasurement> get bodyMeasurements => _bodyMeasurements;
  bool get isLoading => _isLoading;

  BodyMeasurementProvider(this._repository);

  Future<void> loadBodyMeasurements(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final measurements = await _repository.fetchBodyMeasurements(uid);
      _bodyMeasurements = measurements;
    } catch (e) {
      print('Error loading body measurements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
