import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../services/firebase_services.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final WorkoutModel? exercise;
  const WorkoutDetailScreen({this.exercise, Key? key}) : super(key: key);

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final _nameController = TextEditingController();
  final _motaController = TextEditingController();
  final _timeController = TextEditingController();
  final _levelController = TextEditingController();
  final _muscleGroupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      _nameController.text = widget.exercise!.name;
      _motaController.text = widget.exercise!.mota;
      _timeController.text = widget.exercise!.time;
      _levelController.text = widget.exercise!.level;
      _muscleGroupController.text = widget.exercise!.muscleGroup;
    }
  }

  void _saveExercise() {
    final exercise = WorkoutModel(
      id: widget.exercise?.id ?? '',
      name: _nameController.text,
      mota: _motaController.text,
      time: _timeController.text,
      level: _levelController.text,
      muscleGroup: _muscleGroupController.text,
      imageUrl: '', // xử lý thêm sau nếu có ảnh
    );

    if (widget.exercise == null) {
      FirebaseService.addWorkout(exercise);
    } else {
      FirebaseService.updateWorkout(exercise);
    }

    Navigator.pop(context);
  }

  void _deleteExercise() {
    if (widget.exercise != null) {
      FirebaseService.deleteWorkout(widget.exercise!.id);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise == null ? 'Thêm bài tập' : 'Sửa bài tập'),
        actions:
            widget.exercise != null
                ? [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteExercise,
                  ),
                ]
                : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên bài tập'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _motaController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Thời gian'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _levelController,
                decoration: const InputDecoration(labelText: 'Độ khó'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _muscleGroupController,
                decoration: const InputDecoration(labelText: 'Nhóm cơ'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveExercise,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
