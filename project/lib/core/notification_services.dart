import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../data/models/notification.dart'; // File bạn gửi ở trên
import 'package:flutter/material.dart';
import '../data/models/message.dart';

class NotificationService {
  static Future<void> initializeAwesome() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: const Color(0xFF9D50DD),
        importance: NotificationImportance.High,
      ),
    ], debug: true);
  }

  static Future<void> requestPermission() async {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static Future<void> showNotification(AppNotification appNotification) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: appNotification.title,
        body: appNotification.body,
        payload: {
          'id': appNotification.id,
          'type': appNotification.type.toString(),
          'sender': appNotification.sender ?? '',
        },
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    if (message.data.isNotEmpty) {
      Message newMessage = Message.fromDatabase(message.data);
      AppNotification appNotification = AppNotification.fromMessage(newMessage);
      await showNotification(appNotification);
    }
  }
}
