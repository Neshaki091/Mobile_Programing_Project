class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final String mota;
  final String time;
  final String level; // độ khó
  final String muscleGroup; // nhóm cơ

  Workout({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.mota,
    required this.time,
    required this.level,
    required this.muscleGroup,
  });

  factory Workout.fromMap(Map<String, dynamic> map, String id) {
    return Workout(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      mota: map['mo_ta'] ?? '',
      time: map['time'] ?? '',
      level: map['level'] ?? '',
      muscleGroup: map['muscle_group'] ?? '', // <-- thêm dòng này
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'mo_ta': mota,
      'time': time,
      'level': level,
      'muscle_group': muscleGroup, // <-- thêm dòng này
    };
  }
}
