import 'package:cloud_firestore/cloud_firestore.dart';

class BodyMeasurement {
  final String? id;
  final String userId;
  final double bust;
  final double waist;
  final double hip;
  final Timestamp createdAt;
  final String date;

  BodyMeasurement({
    this.id,
    required this.userId,
    required this.bust,
    required this.waist,
    required this.hip,
    required this.createdAt,
    required this.date,
  });

  factory BodyMeasurement.fromMap(Map<String, dynamic> map, {String? id}) {
    return BodyMeasurement(
      id: id,
      userId: map['userId'] ?? map['uid'] ?? '',
      bust: (map['bust'] ?? 0).toDouble(),
      waist: (map['waist'] ?? 0).toDouble(),
      hip: (map['hip'] ?? 0).toDouble(),
      createdAt: map['createdAt'] ?? Timestamp.now(),
      date: map['date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bust': bust,
      'waist': waist,
      'hip': hip,
      'createdAt': createdAt,
      'date': date,
    };
  }
}