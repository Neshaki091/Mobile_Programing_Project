class UserProfile {
  final String uid;
  final String email;
  final String name;
  final double height;
  final double weight;
  final List<String> favorites; // Danh sách ID bài tập yêu thích
  final List<String> myWorkouts; // Danh sách ID bài tập của tôi

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.height,
    required this.weight,
    required this.favorites,
    required this.myWorkouts,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      name: map['name'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      favorites: List<String>.from(map['favorites'] ?? []),
      myWorkouts: List<String>.from(map['myWorkouts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'height': height,
      'weight': weight,
      'favorites': favorites,
      'myWorkouts': myWorkouts,
    };
  }
}
