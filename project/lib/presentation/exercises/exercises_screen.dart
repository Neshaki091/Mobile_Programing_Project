import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/workout_widget.dart';
import '../../widgets/appBar_widget.dart';
import '../../routes/app_routes.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int currentIndex = 1;
  String searchQuery = '';
  String selectedMuscleGroup = 'Tất cả';
  String selectedDifficulty = 'Tất cả';

  final List<String> muscleGroups = [
    'Tất cả',
    'Ngực',
    'Lưng',
    'Chân',
    'Vai',
    'Tay',
  ];
  final List<String> difficulties = ['Tất cả', 'Dễ', 'Trung bình', 'Khó'];

  void onTap(int index) {
    setState(() => currentIndex = index);
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.workout);
        break;
      case 3:
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.community);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
    Provider.of<WorkoutProvider>(context, listen: false).loadMyWorkouts();
  }

  List filterWorkouts(List workouts) {
    return workouts.where((workout) {
      final nameMatch = workout.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final muscleMatch =
          selectedMuscleGroup == 'Tất cả' ||
          workout.muscleGroup == selectedMuscleGroup;
      final difficultyMatch =
          selectedDifficulty == 'Tất cả' || workout.level == selectedDifficulty;
      return nameMatch && muscleMatch && difficultyMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final allWorkouts = workoutProvider.workouts;
    final filteredWorkouts = filterWorkouts(allWorkouts);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách bài tập')),
      body:
          allWorkouts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm bài tập...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => searchQuery = value);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<String>(
                        value: selectedMuscleGroup,
                        items:
                            muscleGroups
                                .map(
                                  (group) => DropdownMenuItem(
                                    value: group,
                                    child: Text(group),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() => selectedMuscleGroup = value!);
                        },
                      ),
                      DropdownButton<String>(
                        value: selectedDifficulty,
                        items:
                            difficulties
                                .map(
                                  (level) => DropdownMenuItem(
                                    value: level,
                                    child: Text(level),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() => selectedDifficulty = value!);
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredWorkouts.length,
                      itemBuilder: (context, index) {
                        return ExerciseItemWidget(
                          workout: filteredWorkouts[index],
                          onAddToMyWorkouts: () {
                            workoutProvider.addToMyWorkouts(
                              filteredWorkouts[index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
