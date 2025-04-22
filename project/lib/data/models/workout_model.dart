class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final String mota;
  final String time;
  final String level;

  Workout({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.mota,
    required this.time,
    required this.level,
  });

  factory Workout.fromMap(Map<String, dynamic> map, String id) {
    return Workout(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      mota: map['mo_ta'] ?? '',
      time: map['time'] ?? '',
      level: map['level'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'mo_ta': mota,
      'time': time,
      'level': level, // <- đúng giá trị biến level
    };
  }
}