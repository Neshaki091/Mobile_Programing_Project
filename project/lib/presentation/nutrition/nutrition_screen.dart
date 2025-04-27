// lib/screens/nutrition/nutrition_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/nutrition_repository.dart';
import '../../providers/nutrition_provider.dart';
import '../../widgets/nutrition_provider.dart';
import '../../routes/app_routes.dart';

class NutritionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = NutritionProvider(NutritionRepository());
        provider.loadNutritionData(); // Load data khi khởi tạo
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

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.nutritionDetail,
                      arguments: data[index],
                    );
                  },
                  child: NutritionItem(item: data[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
