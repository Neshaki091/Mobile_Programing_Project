import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:project/data/models/workoutSchedule.dart';
import '../data/models/message.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String _channelKey = 'fitness_channel';
  static const int _dailyMorningId = 100;
  static const int _dailyAfternoonId = 101;
  static const int _messageIdBase = 200;
  static const int _scheduleIdBase = 300;
  static const int _testId = 400;

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/app_icon', // Biểu tượng nhỏ mặc định
      [
        NotificationChannel(
          channelKey: _channelKey,
          channelName: 'Fitness Notifications',
          channelDescription: 'Channel for workout and message notifications',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          soundSource: null,
          ledColor: Colors.white,
        ),
      ],
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceived,
      onNotificationCreatedMethod: onNotificationCreated,
      onNotificationDisplayedMethod: onNotificationDisplayed,
      onDismissActionReceivedMethod: onDismissActionReceived,
    );

    await AwesomeNotifications().cancelAll();
    await _requestNotificationPermissions();
  }

  static Future<void> onActionReceived(ReceivedAction receivedAction) async {
    final payload = receivedAction.payload;
    if (payload != null) {
      if (payload.containsKey('day')) {
        navigatorKey.currentState?.pushNamed(
          '/workout-schedule',
          arguments: {
            'day': payload['day'],
            'exercises': _safeJsonDecode(payload['exercises']),
          },
        );
      } else if (payload.containsKey('sender_id')) {
        navigatorKey.currentState?.pushNamed(
          '/messages',
          arguments: {
            'sender_id': payload['sender_id'],
            'sender_name': payload['sender_name'] ?? 'Unknown',
            'message_text': payload['text'] ?? '',
            if (payload.containsKey('avatar_url'))
              'avatar_url': payload['avatar_url'],
          },
        );
      }
    }
  }

  static Future<void> onNotificationCreated(
    ReceivedNotification notification,
  ) async {
    debugPrint('Notification created: ID = ${notification.id}');
  }

  static Future<void> onNotificationDisplayed(
    ReceivedNotification notification,
  ) async {
    debugPrint('Notification displayed: ID = ${notification.id}');
  }

  static Future<void> onDismissActionReceived(ReceivedAction action) async {
    debugPrint('Notification dismissed: ID = ${action.id}');
  }

  Future<void> _requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Có thể thông báo người dùng để cấp quyền
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  Future<void> scheduleDailyNotifications() async {
    await _scheduleDailyNotification(
      id: _dailyMorningId,
      title: 'Morning Workout Reminder',
      body: 'Time for your morning exercise routine!',
      hour: 7,
      minute: 0,
    );

    await _scheduleDailyNotification(
      id: _dailyAfternoonId,
      title: 'Afternoon Workout Reminder',
      body: 'Time for your afternoon exercise session!',
      hour: 14,
      minute: 0,
    );
  }

  Future<void> _scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    debugPrint('Scheduling notification: $hour:$minute');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: _channelKey,
        title: title,
        body: body,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  Future<void> showMessageNotification(Message message) async {
    final int notificationId =
        _messageIdBase + (message.userId.hashCode + message.timestamp);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: _channelKey,
        title:
            message.name.isNotEmpty
                ? 'New message from ${message.name}'
                : 'New message',
        body: message.text,
        notificationLayout: NotificationLayout.Messaging,
        category: NotificationCategory.Message,
        payload: {
          'sender_id': message.userId.toString(),
          'sender_name': message.name,
          'text': message.text,
          'timestamp': message.timestamp.toString(),
          if (message.avatarUrl.isNotEmpty) 'avatar_url': message.avatarUrl,
        },
      ),
    );
  }

  Future<void> showScheduleNotification(WorkoutSchedule schedule) async {
    if (schedule.exercises.isEmpty) return;

    final int notificationId = _scheduleIdBase + schedule.day.hashCode;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: _channelKey,
        title: 'Today\'s Workout: ${schedule.day}',
        body: 'Exercises: ${schedule.exercises.join(', ')}',
        notificationLayout: NotificationLayout.BigText,
        category: NotificationCategory.Reminder,
        payload: {
          'day': schedule.day,
          'exercises': jsonEncode(schedule.exercises),
          'exercise_count': schedule.exercises.length.toString(),
        },
      ),
    );
  }

  Future<void> testNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: _testId,
        channelKey: _channelKey,
        title: 'Test Notification',
        body: 'This is a test notification from Fitness App',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static List<dynamic> _safeJsonDecode(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded;
      }
    } catch (e) {
      debugPrint('JSON Decode Error: $e');
    }
    return [];
  }
}
