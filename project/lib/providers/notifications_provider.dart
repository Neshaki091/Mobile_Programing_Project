import 'package:flutter/material.dart';
import '../data/models/notification.dart';
import '../data/repositories/notification_repository.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationRepository _repository;
  final List<AppNotification> _notifications = [];

  NotificationProvider(this._repository);

  List<AppNotification> get notifications => List.unmodifiable(
    _notifications..sort((a, b) => b.time.compareTo(a.time)),
  );

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    final fetchedNotifications = await _repository.getNotifications();
    _notifications
      ..clear()
      ..addAll(fetchedNotifications);
    notifyListeners();
  }

  Future<void> addNotification(AppNotification notification) async {
    await _repository.saveNotification(notification);
    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      _notifications[index] = notification;
    } else {
      _notifications.add(notification);
    }
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAsRead(id);
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    await _repository.clearAll();
    _notifications.clear();
    notifyListeners();
  }
}
