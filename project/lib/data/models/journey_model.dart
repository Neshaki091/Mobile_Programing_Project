import 'package:cloud_firestore/cloud_firestore.dart';

class Journey {
  final String id;
  final String name;
  final String startLocation;
  final String endLocation;
  final List<String> stops;
  final DateTime startTime;

  Journey({
    required this.id,
    required this.name,
    required this.startLocation,
    required this.endLocation,
    required this.stops,
    required this.startTime,
  });

  factory Journey.fromMap(Map<String, dynamic> data, String id) {
    return Journey(
      id: id,
      name: data['name'],
      startLocation: data['startLocation'],
      endLocation: data['endLocation'],
      stops: List<String>.from(data['stops']),
      startTime: (data['startTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'stops': stops,
      'startTime': startTime,
    };
  }
}
