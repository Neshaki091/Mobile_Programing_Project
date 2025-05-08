import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/nutrition_repository.dart';
import '../../providers/nutrition_provider.dart';
import '../../widgets/nutrition_provider.dart';

class NutritionScreen extends StatefulWidget {
  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = NutritionProvider(NutritionRepository());
        provider.loadNutritionData();
        return provider;
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Nutrition')),
        body: Consumer<NutritionProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }

            final data = provider.nutritionData;

            // Lọc theo tên thực phẩm
            final filteredData =
                data.where((item) {
                  final name =
                      item['food_name']?.toString().toLowerCase() ?? '';
                  return name.contains(searchQuery.toLowerCase());
                }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm thực phẩm...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      return NutritionItem(item: filteredData[index]);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
