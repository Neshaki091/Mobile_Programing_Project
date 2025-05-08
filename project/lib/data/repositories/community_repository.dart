import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';
import '../models/user_model.dart'; // Đảm bảo có model này
import '../repositories/auth_repository.dart';

class CommunityRepository {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref(
    'messages',
  );
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  final AuthRepository _authRepo = AuthRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gửi tin nhắn mới
  Future<void> sendMessage(String text, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newMessageRef = _messagesRef.push();

      final userProfile = await _authRepo.getUserProfile(userId);
      final currentUser = _auth.currentUser;

      final message = {
        'text': text.trim(),
        'userId': userId,
        'timestamp': timestamp,
        'name': userProfile?.name ?? currentUser?.displayName ?? 'Người dùng',
        'avatarUrl': currentUser?.photoURL ?? userProfile?.avatarUrl ?? '',
      };

      await newMessageRef.set(message);
    } catch (e) {
      print("Lỗi khi gửi tin nhắn: $e");
    }
  }

  Future<List<UserProfile>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  /// Lấy danh sách tin nhắn theo thời gian thực (Stream)
  Stream<List<Message>> getMessages() {
    return _messagesRef.orderByChild('timestamp').onValue.map((event) {
      final messages = <Message>[];
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        final rawMap = Map<String, dynamic>.from(data);
        rawMap.forEach((key, value) {
          try {
            final messageMap = Map<String, dynamic>.from(value);
            final message = Message.fromDatabase(messageMap);
            messages.add(message);
          } catch (e) {
            print("Lỗi khi chuyển đổi dữ liệu tin nhắn: $e");
          }
        });

        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      return messages;
    });
  }

  /// Tìm kiếm người dùng theo tên (hoặc email, v.v.)
  Future<List<UserProfile>> searchUsersByName(String query) async {
    final snapshot = await _usersRef.once();
    final List<UserProfile> results = [];

    if (snapshot.snapshot.exists && snapshot.snapshot.value is Map) {
      final usersMap = Map<String, dynamic>.from(
        snapshot.snapshot.value as Map,
      );
      usersMap.forEach((key, value) {
        try {
          final userData = Map<String, dynamic>.from(value);
          final user = UserProfile.fromMap(userData);
          if (user.name.toLowerCase().contains(query.toLowerCase())) {
            results.add(user);
          }
        } catch (e) {
          print("Lỗi khi đọc người dùng: $e");
        }
      });
    }

    return results;
  }
}
