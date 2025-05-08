import 'package:flutter/material.dart';

class NutritionItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const NutritionItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = item['food_imageUrl'];
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageUrl != null
                ? Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
                : Container(color: Colors.blue, width: 100, height: 100),
            SizedBox(width: 16),
            Column(
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
          ],
        ),
      ),
    );
  }
}
