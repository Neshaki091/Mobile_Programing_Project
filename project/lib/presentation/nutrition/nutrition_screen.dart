import 'package:flutter/material.dart';
import '../../data/repositories/nutrition_repository.dart';

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final NutritionRepository _repo = NutritionRepository();
  List<Map<String, dynamic>> _nutritionData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _repo.fetchNutritionData();
      setState(() {
        _nutritionData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Lỗi khi tải dữ liệu';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nutrition')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                itemCount: _nutritionData.length,
                itemBuilder: (context, index) {
                  return NutritionItem(item: _nutritionData[index]);
                },
              ),
    );
  }
}

class NutritionItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const NutritionItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = item['food_name'] ?? 'Không rõ';
    final calories = item['calories'] ?? 'N/A';
    final protein = item['nutrients']?['protein'] ?? 'N/A';
    final carbs = item['nutrients']?['carbohydrates']?['total'] ?? 'N/A';
    final fat = item['nutrients']?['fat']?['total'] ?? 'N/A';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Calories: $calories'),
            Text('Protein: $protein'),
            Text('Carbohydrates: $carbs'),
            Text('Fat: $fat'),
          ],
        ),
      ),
    );
  }
}
