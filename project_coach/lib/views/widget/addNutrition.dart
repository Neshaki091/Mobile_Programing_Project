// add_nutrition_screen.dart
import 'package:flutter/material.dart';

class AddNutritionScreen extends StatelessWidget {
  const AddNutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Dinh Dưỡng')),
      body: const Center(child: Text('Form thêm dinh dưỡng ở đây')),
    );
  }
}
