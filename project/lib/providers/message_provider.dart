import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../core/notification.dart';
import '../data/models/message.dart';

class MessageProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService;

  List<Message> _messages = [];
  StreamSubscription? _messagesSubscription;

  MessageProvider() : _notificationService = NotificationService();

  List<Message> get messages => List.unmodifiable(_messages);

  // Khởi tạo lắng nghe tin nhắn
  void initializeMessages() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    _messagesSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          final newMessages =
              snapshot.docs
                  .map((doc) => Message.fromDatabase(doc.data()))
                  .toList();

          // Kiểm tra tin nhắn mới và hiển thị thông báo nếu có
          if (_messages.isNotEmpty && newMessages.isNotEmpty) {
            final latestMessage = newMessages.first;
            if (_messages.first.timestamp != latestMessage.timestamp) {
              _showNewMessageNotification(latestMessage);
            }
          }

          _messages = newMessages;
          notifyListeners();
        });
  }

  // Hiển thị thông báo khi có tin nhắn mới
  Future<void> _showNewMessageNotification(Message message) async {
    try {
      await _notificationService.showMessageNotification(message);
    } catch (e) {
      print("Lỗi khi hiển thị thông báo: $e");
    }
  }

  // Gửi tin nhắn
  Future<void> sendMessage({
    required String recipientId,
    required String text,
    String? name,
    String? avatarUrl,
  }) async {
    final senderId = _auth.currentUser?.uid;
    if (senderId == null) return;

    final message = Message(
      text: text,
      userId: senderId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      name: name ?? 'Unknown',
      avatarUrl: avatarUrl ?? '',
    );

    // Lưu tin nhắn vào Firestore cho người nhận
    await _firestore
        .collection('users')
        .doc(recipientId)
        .collection('messages')
        .add(message.toMap());

    // Lưu tin nhắn vào Firestore cho người gửi (tùy chọn)
    await _firestore
        .collection('users')
        .doc(senderId)
        .collection('sent_messages')
        .add(message.toMap());
  }

  // Đánh dấu tin nhắn đã đọc
  Future<void> markAsRead(String messageId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .doc(messageId)
        .update({'read': true});
  }

  // Xóa tất cả tin nhắn
  Future<void> clearMessages() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final messages =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('messages')
            .get();

    for (var doc in messages.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    _messages.clear();
    notifyListeners();
  }

  // Hủy lắng nghe tin nhắn khi không còn sử dụng
  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
