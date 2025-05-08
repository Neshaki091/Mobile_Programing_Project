class NutritionModel {
  final String food_imageUrl;
  final String foodName;
  final String calories;
  final String protein;
  final Carbohydrates carbohydrates;
  final Fat fat;

  NutritionModel({
    required this.food_imageUrl,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      food_imageUrl: json['food_imageUrl'] ?? '',
      foodName: json['food_name'] ?? '',
      calories: json['calories'] ?? '',
      protein: json['nutrients']['protein'] ?? '',
      carbohydrates: Carbohydrates.fromJson(json['nutrients']['carbohydrates']),
      fat: Fat.fromJson(json['nutrients']['fat']),
    );
  }
}

class Carbohydrates {
  final String total;
  final String sugar;

  Carbohydrates({required this.total, required this.sugar});

  factory Carbohydrates.fromJson(Map<String, dynamic> json) {
    return Carbohydrates(
      total: json['total'] ?? '',
      sugar: json['sugar'] ?? '',
    );
  }
}

class Fat {
  final String total;
  final String saturated;
  final String monounsaturated;
  final String polyunsaturated;

  Fat({
    required this.total,
    required this.saturated,
    required this.monounsaturated,
    required this.polyunsaturated,
  });

  factory Fat.fromJson(Map<String, dynamic> json) {
    return Fat(
      total: json['total'] ?? '',
      saturated: json['saturated'] ?? '',
      monounsaturated: json['monounsaturated'] ?? '',
      polyunsaturated: json['polyunsaturated'] ?? '',
    );
  }
}
