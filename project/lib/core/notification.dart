import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _channelKey = 'fitness_channel';

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // dùng icon mặc định nếu không có resource://drawable/app_icon
      [
        NotificationChannel(
          channelKey: _channelKey,
          channelName: 'Fitness Notifications',
          channelDescription: 'Workout reminders for daily schedule',
          defaultColor: Colors.teal,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
      debug: true,
    );
  }

  /// Lên lịch thông báo vào một thời điểm cụ thể trong ngày
  Future<void> scheduleNotificationAtTime(
    int hour,
    int minute,
    int id,
    String title,
    String body,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: true,
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      ),
    );
  }

  /// Hủy toàn bộ thông báo đã lên lịch
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  /// Hiển thị thông báo ngay lập tức
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
