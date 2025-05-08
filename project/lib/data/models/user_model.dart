import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final double height;
  final double weight;
  final String avatarUrl;
  final int? age;
  final bool isMale;
  final List<String> friends;
  final List<String> favorites;
  final List<String> myWorkouts;
  final String? fcmToken; // Thêm fcmToken
  final int morningHour; // Giờ thông báo sáng
  final int morningMinute; // Phút thông báo sáng
  final int afternoonHour; // Giờ thông báo chiều
  final int afternoonMinute; // Phút thông báo chiều

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.height,
    required this.weight,
    this.avatarUrl = '',
    this.age,
    this.isMale = true,
    required this.favorites,
    required this.myWorkouts,
    required this.friends,
    this.fcmToken, // Thêm constructor param
    this.morningHour = 7,
    this.morningMinute = 0,
    this.afternoonHour = 14,
    this.afternoonMinute = 0,
  });

  // Tạo UserProfile từ Map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      name: map['name'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      avatarUrl: map['avatarUrl'] ?? '',
      age: map['age'],
      isMale: map['isMale'] ?? true,
      favorites: List<String>.from(map['favorites'] ?? []),
      myWorkouts: List<String>.from(map['myWorkouts'] ?? []),
      friends: List<String>.from(map['friends'] ?? []),
      fcmToken: map['fcmToken'],
      morningHour: map['morningHour'] ?? 7,
      morningMinute: map['morningMinute'] ?? 0,
      afternoonHour: map['afternoonHour'] ?? 14,
      afternoonMinute: map['afternoonMinute'] ?? 0,
    );
  }

  // Tạo UserProfile từ Firestore DocumentSnapshot
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      height: (data['height'] ?? 0).toDouble(),
      weight: (data['weight'] ?? 0).toDouble(),
      avatarUrl: data['avatarUrl'] ?? '',
      age: data['age'],
      isMale: data['isMale'] ?? true,
      favorites: List<String>.from(data['favorites'] ?? []),
      myWorkouts: List<String>.from(data['myWorkouts'] ?? []),
      friends: List<String>.from(data['friends'] ?? []),
      fcmToken: data['fcmToken'],
      morningHour: data['morningHour'] ?? 7,
      morningMinute: data['morningMinute'] ?? 0,
      afternoonHour: data['afternoonHour'] ?? 14,
      afternoonMinute: data['afternoonMinute'] ?? 0,
    );
  }

  // Chuyển UserProfile thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'height': height,
      'weight': weight,
      'avatarUrl': avatarUrl,
      'age': age,
      'isMale': isMale,
      'favorites': favorites,
      'myWorkouts': myWorkouts,
      'friends': friends,
      'fcmToken': fcmToken,
      'morningHour': morningHour,
      'morningMinute': morningMinute,
      'afternoonHour': afternoonHour,
      'afternoonMinute': afternoonMinute,
    };
  }
}
