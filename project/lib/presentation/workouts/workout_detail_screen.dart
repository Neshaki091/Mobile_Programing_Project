import 'package:flutter/material.dart';
import '../../data/models/workout_model.dart';
import '../../data/repositories/workout_repository.dart';
import '../../widgets/appBar_widget.dart';
import '../../routes/app_routes.dart';

class MyExerciseScreen extends StatefulWidget {
  const MyExerciseScreen({super.key});

  @override
  State<MyExerciseScreen> createState() => _MyExerciseScreenState();
}

class _MyExerciseScreenState extends State<MyExerciseScreen> {
  final WorkoutRepository _repo = WorkoutRepository();
  int currentIndex = 2;
  List<Workout> selectedExercises = [];
  void onTap(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        // Ở Home rồi
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.exercises);
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.workout);
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
    }
  }

  void _showExerciseDialog() async {
    final exercises = await _repo.fetchWorkouts();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                      setState(() {
                        if (!selectedExercises.any(
                          (e) => e.id == exercise.id,
                        )) {
                          selectedExercises.add(exercise);
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          selectedExercises.isEmpty
              ? const Center(child: Text("Chưa chọn bài tập nào."))
              : ListView.builder(
                itemCount: selectedExercises.length,
                itemBuilder: (context, index) {
                  final exercise = selectedExercises[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading:
                          exercise.imageUrl.isNotEmpty
                              ? Image.network(
                                exercise.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.image),
                      title: Text(exercise.name),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showExerciseDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
