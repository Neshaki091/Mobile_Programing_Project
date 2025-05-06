import 'package:flutter/material.dart';
import 'package:project/presentation/exercises/exercise_detail_screen.dart';
import 'package:project/presentation/workouts/workout_detail_screen.dart';
import '../data/models/workout_model.dart';

class ExerciseItemWidget extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onAddToMyWorkouts;
  final VoidCallback? onRemoveFromMyWorkouts;

  const ExerciseItemWidget({
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
        color: Theme.of(context).brightness == Brightness.light 
              ? Colors.white 
              : Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.withOpacity(0.2)
                : Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetailScreen(workout: workout),
            ),
          );
        },
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
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.whatshot, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(
                        workout.level,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onAddToMyWorkouts != null)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: onAddToMyWorkouts,
              ),
            if (onRemoveFromMyWorkouts != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onRemoveFromMyWorkouts,
              ),
          ],
        ),
      ),
    );
  }
}

class WorkoutItemWidget extends StatelessWidget {
  final Workout workout;
  final VoidCallback? onAddToMyWorkouts;
  final VoidCallback? onAddToFavorites;
  final VoidCallback? onRemoveFromFavorites;
  final bool isFavorite; // Thêm thuộc tính isFavorite để đổi icon

  const WorkoutItemWidget({
    Key? key,
    required this.workout,
    this.onAddToMyWorkouts,
    this.onAddToFavorites,
    this.onRemoveFromFavorites,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // Thêm InkWell ở đây
      onTap: () {
        // Điều hướng đến trang chi tiết workout
        Navigator.push(
          context,
          MaterialPageRoute(
            // Thay thế bằng trang bạn muốn điều hướng đến
            builder: (context) => WorkoutDetailScreen(exercises: [],
              workoutName: workout.name,
              workoutTime: workout.time,
            ),
          ),
        );
      },
      child: Container(
        width: 160, // Nhỏ gọn để kéo ngang
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light 
              ? Colors.white 
              : Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.withOpacity(0.2)
                : Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    workout.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        onRemoveFromFavorites?.call();
                      } else {
                        onAddToFavorites?.call();
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                workout.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (onAddToMyWorkouts != null)
              TextButton(
                onPressed: onAddToMyWorkouts,
                child: const Text('Thêm vào của tôi'),
              ),
          ],
        ),
      ),
    );
  }
}
