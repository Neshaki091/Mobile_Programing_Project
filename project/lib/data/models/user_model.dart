class UserProfile {
  final String uid;
  final String email;
  final String name;
  final double height;
  final double weight;
  final String avatarUrl;
  final List<String> favorites; // Danh sách ID bài tập yêu thích
  final List<String> myWorkouts; // URL của ảnh đại diện
  // Lịch tập

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.height,
    required this.weight,
    this.avatarUrl = '',
    required this.favorites,
    required this.myWorkouts // Khởi tạo avatarUrl với giá trị mặc định
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      name: map['name'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      favorites: List<String>.from(map['favorites'] ?? []),
      myWorkouts: List<String>.from(map['myWorkouts'] ?? []), // Lấy URL ảnh đại diện từ map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'height': height,
      'weight': weight, // Lưu URL ảnh đại diện vào map
    };
  }
}
