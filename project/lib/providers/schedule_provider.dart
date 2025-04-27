import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/notification.dart';
import '../data/models/workoutSchedule.dart';

class ScheduleProvider with ChangeNotifier {
  final List<WorkoutSchedule> _schedule = [
    WorkoutSchedule(day: 'MON', exercises: []),
    WorkoutSchedule(day: 'TUE', exercises: []),
    WorkoutSchedule(day: 'WED', exercises: []),
    WorkoutSchedule(day: 'THU', exercises: []),
    WorkoutSchedule(day: 'FRI', exercises: []),
    WorkoutSchedule(day: 'SAT', exercises: []),
    WorkoutSchedule(day: 'SUN', exercises: []),
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notificationService;

  ScheduleProvider() : _notificationService = NotificationService();

  List<WorkoutSchedule> get schedule => List.unmodifiable(_schedule);

  // Hàm khởi tạo để tải dữ liệu từ Firestore hoặc SharedPreferences
  Future<void> initialize() async {
    final user = _auth.currentUser;
    if (user != null) {
      await loadFromFirestore(user.uid);
      await _checkAndNotifyTodaySchedule();
    } else {
      await loadFromLocal();
    }
    await _notificationService.scheduleDailyNotifications();
  }

  // Kiểm tra và thông báo lịch tập của hôm nay
  Future<void> _checkAndNotifyTodaySchedule() async {
    final now = DateTime.now();
    final today =
        ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][now.weekday - 1];
    final todaySchedule = _schedule.firstWhere((s) => s.day == today);

    if (todaySchedule.exercises.isNotEmpty) {
      await _notificationService.showScheduleNotification(todaySchedule);
    }
  }

  // Cập nhật các bài tập cho ngày cụ thể
  void updateExercises(String day, List<String> newExercises) {
    final index = _schedule.indexWhere((s) => s.day == day);
    if (index != -1) {
      _schedule[index].exercises = newExercises;
      notifyListeners();
      _checkAndNotifyTodaySchedule();
    }
  }

  // Lưu lịch tập vào Firestore
  Future<void> saveToFirestore(String uid) async {
    try {
      final data = {for (var item in _schedule) item.day: item.exercises};
      await _firestore.collection('workout_schedules').doc(uid).set(data);
    } catch (e) {
      debugPrint('Error saving to Firestore: $e');
    }
  }

  // Tải lịch tập từ Firestore
  Future<void> loadFromFirestore(String uid) async {
    try {
      final doc =
          await _firestore.collection('workout_schedules').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        for (var item in _schedule) {
          if (data.containsKey(item.day)) {
            item.exercises = List<String>.from(data[item.day]);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading from Firestore: $e');
    }
  }

  // Lưu lịch tập vào SharedPreferences
  Future<void> saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {for (var item in _schedule) item.day: item.exercises};
      await prefs.setString('workout_schedule', jsonEncode(data));
    } catch (e) {
      debugPrint('Error saving to local: $e');
    }
  }

  // Tải lịch tập từ SharedPreferences
  Future<void> loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('workout_schedule');
      if (jsonString != null) {
        final data = jsonDecode(jsonString);
        for (var item in _schedule) {
          if (data.containsKey(item.day)) {
            item.exercises = List<String>.from(data[item.day]);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading from local: $e');
    }
  }

  // Hàm xóa lịch tập (dùng để reset hoặc làm mới)
  void clearSchedule() {
    for (var item in _schedule) {
      item.exercises.clear();
    }
    notifyListeners();
  }
}
