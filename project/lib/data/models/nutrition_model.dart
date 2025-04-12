import 'dart:convert';

class NutritionModel {
  final String foodName;
  final String servingSize;
  final String calories;
  final Nutrients nutrients;
  final Vitamins vitamins;

  NutritionModel({
    required this.foodName,
    required this.servingSize,
    required this.calories,
    required this.nutrients,
    required this.vitamins,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      foodName: json['food_name'] ?? '',
      servingSize: json['serving_size'] ?? '',
      calories: json['calories'] ?? '',
      nutrients: Nutrients.fromJson(json['nutrients']),
      vitamins: Vitamins.fromJson(json['vitamins']),
    );
  }

  static NutritionModel fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return NutritionModel.fromJson(jsonMap);
  }
}

class Nutrients {
  final String protein;
  final Fat fat;
  final Carbohydrates carbohydrates;
  final String cholesterol;
  final String sodium;
  final String potassium;

  Nutrients({
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.cholesterol,
    required this.sodium,
    required this.potassium,
  });

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      protein: json['protein'] ?? '',
      fat: Fat.fromJson(json['fat']),
      carbohydrates: Carbohydrates.fromJson(json['carbohydrates']),
      cholesterol: json['cholesterol'] ?? '',
      sodium: json['sodium'] ?? '',
      potassium: json['potassium'] ?? '',
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

class Carbohydrates {
  final String total;
  final String sugar;

  Carbohydrates({
    required this.total,
    required this.sugar,
  });

  factory Carbohydrates.fromJson(Map<String, dynamic> json) {
    return Carbohydrates(
      total: json['total'] ?? '',
      sugar: json['sugar'] ?? '',
    );
  }
}

class Vitamins {
  final Vitamin vitaminA;
  final Vitamin vitaminD;
  final Vitamin vitaminB12;

  Vitamins({
    required this.vitaminA,
    required this.vitaminD,
    required this.vitaminB12,
  });

  factory Vitamins.fromJson(Map<String, dynamic> json) {
    return Vitamins(
      vitaminA: Vitamin.fromJson(json['vitamin_a']),
      vitaminD: Vitamin.fromJson(json['vitamin_d']),
      vitaminB12: Vitamin.fromJson(json['vitamin_b12']),
    );
  }
}

class Vitamin {
  final String amount;
  final String dailyValue;

  Vitamin({
    required this.amount,
    required this.dailyValue,
  });

  factory Vitamin.fromJson(Map<String, dynamic> json) {
    return Vitamin(
      amount: json['amount'] ?? '',
      dailyValue: json['daily_value'] ?? '',
    );
  }
}
