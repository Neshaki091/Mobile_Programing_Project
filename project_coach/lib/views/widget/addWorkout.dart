import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/workout_model.dart';
import '../../services/cloudinary_service.dart';
import '../../services/firebase_services.dart';
import '../../viewmodels/workout_viewmodel.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _motaController = TextEditingController();
  final _timeController = TextEditingController();
  final _levelController = TextEditingController();
  final _muscleGroupController = TextEditingController();

  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng chọn ảnh")));
      return;
    }

    setState(() => _isUploading = true);

    try {
      final imageUrl = await CloudinaryService.uploadImage(_selectedImage!);
      if (imageUrl == null) throw "Không thể tải ảnh lên";

      final newWorkout = WorkoutModel(
        id: '',
        name: _nameController.text.trim(),
        imageUrl: imageUrl,
        mota: _motaController.text.trim(),
        time: _timeController.text.trim(),
        level: _levelController.text.trim(),
        muscleGroup: _muscleGroupController.text.trim(),
      );

      await FirebaseService.addWorkout(newWorkout);
      await Provider.of<WorkoutViewModel>(
        context,
        listen: false,
      ).fetchWorkouts();

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi khi thêm: $e")));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm bài tập')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child:
                      _selectedImage != null
                          ? Image.file(_selectedImage!, height: 150)
                          : Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(child: Text("Chọn ảnh")),
                          ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Tên bài tập"),
                  validator: (val) => val!.isEmpty ? 'Không để trống' : null,
                ),
                TextFormField(
                  controller: _motaController,
                  decoration: const InputDecoration(labelText: "Mô tả"),
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(labelText: "Thời gian"),
                ),
                TextFormField(
                  controller: _levelController,
                  decoration: const InputDecoration(labelText: "Độ khó"),
                ),
                TextFormField(
                  controller: _muscleGroupController,
                  decoration: const InputDecoration(labelText: "Nhóm cơ"),
                ),
                const SizedBox(height: 20),
                _isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Thêm bài tập"),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
