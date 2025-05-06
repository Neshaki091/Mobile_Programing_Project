import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/message.dart';
import '../models/user_model.dart'; // Đảm bảo có model này
import '../repositories/auth_repository.dart';

class CommunityRepository {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref(
    'messages',
  );
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepo = AuthRepository();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Gửi tin nhắn mới
  Future<void> sendMessage(
    String text,
    String receiverId,
    String senderId,
  ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newMessageRef = _messagesRef.push();

      final userProfile = await _authRepo.getUserProfile(senderId);
      final receiverProfile = await _authRepo.getUserProfile(receiverId);

      final message = {
        'text': text.trim(),
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': timestamp,
        'senderName': userProfile?.name ?? 'Người gửi',
        'receiverName': receiverProfile?.name ?? 'Người nhận',
        'senderAvatar': userProfile?.avatarUrl ?? '',
        'receiverAvatar': receiverProfile?.avatarUrl ?? '',
      };

      // Lưu tin nhắn vào Firebase Realtime Database
      await newMessageRef.set(message);

      // Sau khi lưu tin nhắn, gọi hàm gửi thông báo FCM
      await _sendNotification(receiverId, message);
    } catch (e) {
      print("Lỗi khi gửi tin nhắn: $e");
    }
  }

  /// Gửi thông báo qua FCM
  Future<void> _sendNotification(
    String receiverId,
    Map<String, dynamic> message,
  ) async {
    try {
      final receiverUserProfile = await _authRepo.getUserProfile(receiverId);

      if (receiverUserProfile?.fcmToken != null) {
        final notification = {
          'title': '${message['senderName']} đã gửi tin nhắn',
          'body': message['text'],
        };

        final fcmMessage = {
          'to': receiverUserProfile?.fcmToken,
          'notification': notification,
          'data': {
            'senderId': message['senderId'],
            'receiverId': message['receiverId'],
            'messageId': message['timestamp'].toString(),
          },
        };

        // Gửi thông báo qua FirebaseMessaging
        await _firebaseMessaging.sendMessage(
          to: receiverUserProfile?.fcmToken,
          data: fcmMessage.map((key, value) => MapEntry(key, value.toString())),
        );
      }
    } catch (e) {
      print("Lỗi khi gửi thông báo FCM: $e");
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

  /// Lấy danh sách tin nhắn từ phòng chat (chat room)
  Stream<List<Message>> getMessages(String receiverId) {
    final senderId = _auth.currentUser!.uid;
    final chatRoomId = _getChatRoomId(senderId, receiverId);

    return _messagesRef.child(chatRoomId).orderByChild('timestamp').onValue.map(
      (event) {
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
      },
    );
  }

  /// Tạo ID cho phòng chat giữa 2 người
  String _getChatRoomId(String senderId, String receiverId) {
    return senderId.hashCode <= receiverId.hashCode
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';
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
