import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class LearnerService {
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  Future<List<UserProfile>> fetchAllUsers() async {
    try {
      final querySnapshot = await _userCollection.get();
      return querySnapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }
}
