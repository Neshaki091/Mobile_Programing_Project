import 'package:flutter/foundation.dart';
import 'message.dart';

enum NotificationType { workout, message, system, reminder, chatMessage }

@immutable
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;
  final NotificationType type;
  final Map<String, dynamic>? payload;
  final String? sender; // Thêm người gửi (chỉ áp dụng cho loại chatMessage)
  final String? avatarUrl; // Thêm avatarUrl để hiển thị hình ảnh người gửi

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    required this.type,
    this.payload,
    this.sender, // Thêm người gửi
    this.avatarUrl, // Thêm avatarUrl
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      time: DateTime.parse(json['time']),
      isRead: json['isRead'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      payload: json['payload'],
      sender: json['sender'], // Đọc thông tin người gửi từ JSON
      avatarUrl: json['avatarUrl'], // Đọc avatarUrl
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'time': time.toIso8601String(),
      'isRead': isRead,
      'type': type.toString().split('.').last,
      'payload': payload,
      'sender': sender, // Lưu người gửi vào JSON
      'avatarUrl': avatarUrl, // Lưu avatarUrl vào JSON
    };
  }

  AppNotification copyWith({bool? isRead, String? sender, String? avatarUrl}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      time: time,
      isRead: isRead ?? this.isRead,
      type: type,
      payload: payload,
      sender: sender ?? this.sender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  // Hàm tạo AppNotification từ Message
  static AppNotification fromMessage(Message message) {
    return AppNotification(
      id: message.userId, // ID có thể là userId hoặc một giá trị duy nhất
      title: "Tin nhắn mới từ ${message.name}",
      body: message.text,
      time: DateTime.fromMillisecondsSinceEpoch(message.timestamp),
      isRead: false,
      type: NotificationType.chatMessage,
      sender: message.name,
      avatarUrl: message.avatarUrl,
    );
  }
}
