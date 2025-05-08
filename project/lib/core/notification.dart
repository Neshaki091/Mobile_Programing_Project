import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _channelKey = 'fitness_channel';
  static const int _morningId = 100;
  static const int _afternoonId = 101;

  Future<void> initialize() async {
    await AwesomeNotifications().initialize('resource://drawable/app_icon', [
      NotificationChannel(
        channelKey: _channelKey,
        channelName: 'Fitness Notifications',
        channelDescription: 'Workout reminders',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
      ),
    ]);
  }

  /// Lên lịch thông báo hàng ngày vào giờ đã chọn
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
        repeats: true,
      ),
    );
  }

  /// Lên lịch thông báo cho sáng và chiều
  Future<void> scheduleDailyNotifications(
    int morningHour,
    int morningMinute,
    int afternoonHour,
    int afternoonMinute,
  ) async {
    await scheduleNotificationAtTime(
      morningHour,
      morningMinute,
      _morningId,
      'Morning Workout Reminder',
      'It\'s time for your morning workout!',
    );

    await scheduleNotificationAtTime(
      afternoonHour,
      afternoonMinute,
      _afternoonId,
      'Afternoon Workout Reminder',
      'It\'s time for your afternoon workout!',
    );
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<void> sendWorkoutScheduleNotification(
    String title,
    String body,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  // Thêm phương thức kiểm tra thông báo khi ứng dụng khởi động
  Future<void> checkNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final morningHour = prefs.getInt('morningHour') ?? 7;
    final morningMinute = prefs.getInt('morningMinute') ?? 0;
    final afternoonHour = prefs.getInt('afternoonHour') ?? 14;
    final afternoonMinute = prefs.getInt('afternoonMinute') ?? 0;

    // Đặt lại các thông báo
    await scheduleDailyNotifications(
      morningHour,
      morningMinute,
      afternoonHour,
      afternoonMinute,
    );
  }
}
