class WorkoutModel {
  final String id;
  final String name;
  final String imageUrl;
  final String mota;
  final String time;
  final String level; // độ khó
  final String muscleGroup; // nhóm cơ

  WorkoutModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.mota,
    required this.time,
    required this.level,
    required this.muscleGroup,
  });

  factory WorkoutModel.fromMap(Map<String, dynamic> map, String id) {
    return WorkoutModel(
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

extension WorkoutCopy on WorkoutModel {
  WorkoutModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? mota,
    String? time,
    String? level,
    String? muscleGroup,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      mota: mota ?? this.mota,
      time: time ?? this.time,
      level: level ?? this.level,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }
}
