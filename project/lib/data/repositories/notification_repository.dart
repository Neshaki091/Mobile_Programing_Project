import '../../data/models/notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
  Future<void> saveNotification(AppNotification notification);
  Future<void> markAsRead(String id);
  Future<void> clearAll();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final List<AppNotification> _notifications = [];

  @override
  Future<List<AppNotification>> getNotifications() async {
    _notifications.sort((a, b) => b.time.compareTo(a.time));
    return List<AppNotification>.from(_notifications);
  }

  @override
  Future<void> saveNotification(AppNotification notification) async {
    // Nếu notification trùng id, update, nếu không thêm mới
    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      _notifications[index] = notification;
    } else {
      _notifications.add(notification);
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final current = _notifications[index];
      _notifications[index] = current.copyWith(isRead: true);
    }
  }

  @override
  Future<void> clearAll() async {
    _notifications.clear();
  }
}
