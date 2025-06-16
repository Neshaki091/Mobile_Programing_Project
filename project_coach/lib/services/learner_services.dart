import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class LearnerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy toàn bộ học viên từ Firestore
  Future<List<UserProfile>> getAllLearners() async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'learner')
              .get();

      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách học viên: $e');
      return [];
    }
  }

  /// Tìm kiếm học viên theo tên
  Future<List<UserProfile>> searchLearnersByName(String query) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('role', isEqualTo: 'learner')
              .get();

      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc))
          .where(
            (user) => user.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      print('Lỗi khi tìm kiếm học viên: $e');
      return [];
    }
  }
}
