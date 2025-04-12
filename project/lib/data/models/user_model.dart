class UserProfile {
  final String uid;
  final String email;
  final String name;
  final double height;
  final double weight;
  final List<String> schedule; // Lịch tập

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.height,
    required this.weight,
    required this.schedule,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      name: map['name'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      schedule: List<String>.from(map['schedule'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'height': height,
      'weight': weight,
      'schedule': schedule,
    };
  }
}
