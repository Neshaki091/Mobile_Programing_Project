import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  List<WorkoutSchedule> get schedule => List.unmodifiable(_schedule);

  void updateExercises(String day, List<String> newExercises) {
    final index = _schedule.indexWhere((s) => s.day == day);
    if (index != -1) {
      _schedule[index].exercises = newExercises;
      notifyListeners();
    }
  }

  /// 🔴 Save to Firestore
  Future<void> saveToFirestore(String uid) async {
    try {
      final data = {for (var item in _schedule) item.day: item.exercises};
      await FirebaseFirestore.instance
          .collection('workout_schedules')
          .doc(uid)
          .set(data);
    } catch (e) {
      debugPrint('Error saving to Firestore: $e');
    }
  }

  /// 🟢 Load from Firestore
  Future<void> loadFromFirestore(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('workout_schedules')
              .doc(uid)
              .get();

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

  /// 💾 Save to SharedPreferences (Local)
  Future<void> saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {for (var item in _schedule) item.day: item.exercises};
      await prefs.setString('workout_schedule', jsonEncode(data));
    } catch (e) {
      debugPrint('Error saving to local: $e');
    }
  }

  /// 📥 Load from SharedPreferences (Local)
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

  void clearSchedule() {
    for (var item in _schedule) {
      item.exercises.clear();
    }
    notifyListeners();
  }
}
