import 'package:flutter/material.dart';
import '../data/models/workout_model.dart';

class WorkoutItemWidget extends StatelessWidget {
  final Workout workout;
  final VoidCallback?
  onAddToMyWorkouts; // Callback để thêm bài tập vào "Bài tập của tôi"
  final VoidCallback?
  onRemoveFromMyWorkouts; // Callback để xóa bài tập khỏi "Bài tập của tôi"

  const WorkoutItemWidget({
    Key? key,
    required this.workout,
    this.onAddToMyWorkouts,
    this.onRemoveFromMyWorkouts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                workout.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            // Cột bên trái: Tên bài tập và mức độ
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    Icon(Icons.whatshot, size: 16, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      workout.level,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            // Ảnh bài tập bên phải

            // Nút "Thêm" (nếu có)
            if (onAddToMyWorkouts != null)
              IconButton(
                icon: Icon(Icons.add, color: Colors.blue),
                onPressed: onAddToMyWorkouts,
              ),
            // Nút "Xóa" (nếu có)
            if (onRemoveFromMyWorkouts != null)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: onRemoveFromMyWorkouts,
              ),
          ],
        ),
      ),
    );
  }
}