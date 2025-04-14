class UserProfile {
  final String uid;
  final String email;
  final String name;
  final double height;
  final double weight;
  final String avatarUrl; // URL của ảnh đại diện
  final int? age;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.height,
    required this.weight,
    this.avatarUrl = '', // Khởi tạo avatarUrl với giá trị mặc định
    this.age,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      name: map['name'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(), // Lấy URL ảnh đại diện từ map
      age: map['age'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'height': height,
      'weight': weight, // Lưu URL ảnh đại diện vào map
      'age': age,
    };
  }
}
