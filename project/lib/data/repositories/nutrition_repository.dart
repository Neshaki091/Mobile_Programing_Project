import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchNutritionData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Nutritions').get();

      List<Map<String, dynamic>> fetchedData = [];

      for (var doc in snapshot.docs) {
        final raw = doc.data() as Map<String, dynamic>;

        if (raw.containsKey('Details')) {
          String jsonString = raw['Details'];
          try {
            Map<String, dynamic> decoded = jsonDecode(jsonString);
            fetchedData.add(decoded);
          } catch (e) {
            print('JSON decode error: $e');
          }
        }
      }

      return fetchedData;
    } catch (e) {
      print("Error fetching nutrition data: $e");
      return [];
    }
  }
}
