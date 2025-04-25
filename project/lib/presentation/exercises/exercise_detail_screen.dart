import 'package:flutter/material.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String title;
  final String level;
  final String duration;
  final List<Exercise> exercises;

  const ExerciseDetailScreen({
    Key? key,
    this.title = "Bài tập ngực",
    this.level = "trung bình",
    this.duration = "00 min",
    this.exercises = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài tập'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.grey),
                SizedBox(width: 4),
                Text(level),
                SizedBox(width: 16),
                Icon(Icons.timer_outlined, color: Colors.grey),
                SizedBox(width: 4),
                Text(duration),
              ],
            ),
            const SizedBox(height: 20),
            Text("Exercises (${exercises.length})", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final ex = exercises[index];
                  return ExerciseCard(exercise: ex);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text("Chỉnh Sửa"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Bắt Đầu"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Exercise {
  final String title;
  final String image;
  final String detail;

  Exercise({
    required this.title,
    required this.image,
    required this.detail,
  });
}

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            exercise.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(exercise.title),
        subtitle: Text(exercise.detail),
        onTap: () {}, // tuỳ chỉnh khi nhấn
      ),
    );
  }
}
