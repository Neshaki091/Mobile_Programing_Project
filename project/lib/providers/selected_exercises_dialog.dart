import 'package:flutter/material.dart';
import '../data/repositories/workout_repository.dart';
import '../data/models/workout_model.dart';

class SelectExerciseDialog extends StatelessWidget {
  final WorkoutRepository repo;
  final Function(Workout) onExerciseSelected;

  const SelectExerciseDialog({
    super.key,
    required this.repo,
    required this.onExerciseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Workout>>(
      future: repo.fetchWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final exercises = snapshot.data ?? [];

        return AlertDialog(
          title: const Text("Chọn bài tập"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ListTile(
                  leading:
                      exercise.imageUrl.isNotEmpty
                          ? Image.network(
                            exercise.imageUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.fitness_center),
                  title: Text(exercise.name),
                  onTap: () {
                    onExerciseSelected(exercise);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
