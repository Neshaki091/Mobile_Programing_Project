import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class ChatViewModel {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _realtimeDB = FirebaseDatabase.instance;

  /// Tạo chatRoomId cố định theo 2 userId
  String getChatRoomId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '${uid1}_$uid2' : '${uid2}_$uid1';
  }

  /// Gửi tin nhắn riêng tư
  Future<void> sendPrivateMessage({
    required String toUserId,
    required String text,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final chatRoomId = getChatRoomId(currentUser.uid, toUserId);
      final chatRef = _realtimeDB.ref('private_chats/$chatRoomId');

      final message = {
        'text': text.trim(),
        'userId': currentUser.uid,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'name': currentUser.displayName ?? 'Bạn',
        'avatarUrl': currentUser.photoURL ?? '',
      };

      await chatRef.push().set(message);
      await _sendPushNotification(toUserId, message, chatRoomId);
    } catch (e) {
      print('Lỗi gửi tin nhắn riêng tư: $e');
    }
  }

  /// Lấy tin nhắn theo chatRoomId (Stream)
  Stream<List<MessageModel>> getPrivateMessages(String friendId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Stream.empty();

    final chatRoomId = getChatRoomId(currentUser.uid, friendId);
    final chatRef = _realtimeDB.ref('private_chats/$chatRoomId');

    return chatRef.orderByChild('timestamp').onValue.map((event) {
      final messages = <MessageModel>[];
      final data = event.snapshot.value;

      if (data != null && data is Map) {
        final rawMap = Map<String, dynamic>.from(data);
        rawMap.forEach((key, value) {
          final msgMap = Map<String, dynamic>.from(value);
          final msg = MessageModel.fromDatabase(msgMap);
          messages.add(msg);
        });
        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      return messages;
    });
  }

  /// Gửi FCM notification
  Future<void> _sendPushNotification(
    String toUserId,
    Map<String, dynamic> message,
    String chatRoomId,
  ) async {
    try {
      final doc = await _firestore.collection('users').doc(toUserId).get();
      final token = doc.data()?['fcmToken'];
      if (token == null) return;

      final serverDoc =
          await _firestore.collection('config').doc('server').get();
      final serverUrl = serverDoc.data()?['url'];
      if (serverUrl == null) return;

      final bodyData = {
        "fcmToken": token,
        "title": "Tin nhắn mới từ ${message['name']}",
        "body": message['text'],
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "chat_room_id": chatRoomId,
        },
      };

      final response = await http.post(
        Uri.parse('$serverUrl/send-message-notification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode != 200) {
        print('Gửi thông báo lỗi: ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi gửi FCM: $e');
    }
  }
}
