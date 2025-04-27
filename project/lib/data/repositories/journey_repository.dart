import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/data/models/body_measurement.dart';

class BodyMeasurementRepository {
  final FirebaseFirestore _firestore;

  BodyMeasurementRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<BodyMeasurement>> fetchBodyMeasurements(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('bodyMeasurements')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BodyMeasurement.fromMap(doc.data(), id: doc.id))
          .toList();
    } catch (e) {
      print('Error fetching body measurements: $e');
      return [];
    }
  }
}
