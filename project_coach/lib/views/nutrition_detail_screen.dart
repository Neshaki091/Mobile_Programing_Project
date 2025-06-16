import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/nutrition_model.dart';
import '../viewmodels/nutrition_viewmodel.dart';

class NutritionDetailScreen extends StatefulWidget {
  final NutritionModel? item;
  const NutritionDetailScreen({this.item, Key? key}) : super(key: key);

  @override
  State<NutritionDetailScreen> createState() => _NutritionDetailScreenState();
}

class _NutritionDetailScreenState extends State<NutritionDetailScreen> {
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbTotalController = TextEditingController();
  final _carbSugarController = TextEditingController();
  final _fatTotalController = TextEditingController();
  final _fatSaturatedController = TextEditingController();
  final _fatMonoController = TextEditingController();
  final _fatPolyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.foodName;
      _imageController.text = widget.item!.food_imageUrl;
      _caloriesController.text = widget.item!.calories;
      _proteinController.text = widget.item!.protein;
      _carbTotalController.text = widget.item!.carbohydrates.total;
      _carbSugarController.text = widget.item!.carbohydrates.sugar;
      _fatTotalController.text = widget.item!.fat.total;
      _fatSaturatedController.text = widget.item!.fat.saturated;
      _fatMonoController.text = widget.item!.fat.monounsaturated;
      _fatPolyController.text = widget.item!.fat.polyunsaturated;
    }
  }

  void _saveItem() async {
    final viewModel = Provider.of<NutritionViewModel>(context, listen: false);

    final newItem = NutritionModel(
      food_imageUrl: _imageController.text,
      foodName: _nameController.text,
      calories: _caloriesController.text,
      protein: _proteinController.text,
      carbohydrates: Carbohydrates(
        total: _carbTotalController.text,
        sugar: _carbSugarController.text,
      ),
      fat: Fat(
        total: _fatTotalController.text,
        saturated: _fatSaturatedController.text,
        monounsaturated: _fatMonoController.text,
        polyunsaturated: _fatPolyController.text,
      ),
    );

    if (widget.item == null) {
      await viewModel.addSingle(newItem);
    } else {
      await viewModel.updateSingle(newItem);
    }

    if (mounted) Navigator.pop(context);
  }

  void _deleteItem() async {
    final viewModel = Provider.of<NutritionViewModel>(context, listen: false);
    if (widget.item != null) {
      await viewModel.deleteSingle(widget.item!);
    }
    if (mounted) Navigator.pop(context);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Thêm thực phẩm' : 'Sửa thực phẩm'),
        actions:
            widget.item != null
                ? [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _deleteItem,
                  ),
                ]
                : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              'Tên thực phẩm',
              _nameController,
              TextInputType.text,
            ),
            _buildTextField(
              'URL hình ảnh',
              _imageController,
              TextInputType.url,
            ),
            _buildTextField(
              'Calories',
              _caloriesController,
              TextInputType.number,
            ),
            _buildTextField(
              'Protein (g)',
              _proteinController,
              TextInputType.number,
            ),
            _buildTextField(
              'Carbs tổng (g)',
              _carbTotalController,
              TextInputType.number,
            ),
            _buildTextField(
              'Đường (g)',
              _carbSugarController,
              TextInputType.number,
            ),
            _buildTextField(
              'Fat tổng (g)',
              _fatTotalController,
              TextInputType.number,
            ),
            _buildTextField(
              'Fat bão hòa (g)',
              _fatSaturatedController,
              TextInputType.number,
            ),
            _buildTextField(
              'Fat mono (g)',
              _fatMonoController,
              TextInputType.number,
            ),
            _buildTextField(
              'Fat poly (g)',
              _fatPolyController,
              TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveItem, child: const Text('Lưu')),
          ],
        ),
      ),
    );
  }
}
