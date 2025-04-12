import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/authentic_provider.dart';

class EditScheduleScreen extends StatelessWidget {
  final List<String> allExercises = [
    'Ngực',
    'Lưng',
    'Chân',
    'Vai',
    'Tay Trước',
    'Tay Sau',
    'Cẳng Tay',
    'Bụng',
  ];

  Future<void> _saveSchedule(BuildContext context) async {
    final workoutProvider = Provider.of<WorkoutProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthenticProvider>(context, listen: false);
    final uid = authProvider.user?.uid;

    if (uid != null) {
      await workoutProvider.saveToFirestore(uid);
    }

    await workoutProvider.saveToLocal();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu lịch tập thành công!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa lịch tập')),
      body: ListView(
        children:
            workoutProvider.schedule.map((schedule) {
              return ExpansionTile(
                title: Text(schedule.day),
                children:
                    allExercises.map((exercise) {
                      final isSelected = schedule.exercises.contains(exercise);
                      return CheckboxListTile(
                        value: isSelected,
                        title: Text(exercise),
                        onChanged: (value) {
                          List<String> updated = List.from(schedule.exercises);
                          if (value == true && !updated.contains(exercise)) {
                            updated.add(exercise);
                          } else if (value == false) {
                            updated.remove(exercise);
                          }
                          workoutProvider.updateExercises(
                            schedule.day,
                            updated,
                          );
                        },
                      );
                    }).toList(),
              );
            }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () => _saveSchedule(context),
        tooltip: 'Lưu lịch tập',
      ),
    );
  }
}
