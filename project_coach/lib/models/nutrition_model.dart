class NutritionModel {
  final String? id; // Assuming you have an ID field for the document
  final String food_imageUrl;
  final String foodName;
  final String calories;
  final String protein;
  final Carbohydrates carbohydrates;
  final Fat fat;

  NutritionModel({
    this.id,
    required this.food_imageUrl,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      id: json['id'] ?? '', // Assuming 'id' is part of the JSON
      food_imageUrl: json['food_imageUrl'] ?? '',
      foodName: json['food_name'] ?? '',
      calories: json['calories'] ?? '',
      protein: json['nutrients']['protein'] ?? '',
      carbohydrates: Carbohydrates.fromJson(json['nutrients']['carbohydrates']),
      fat: Fat.fromJson(json['nutrients']['fat']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'food_imageUrl': food_imageUrl,
      'food_name': foodName,
      'calories': calories,
      'nutrients': {
        'protein': protein,
        'carbohydrates': carbohydrates.toJson(),
        'fat': fat.toJson(),
      },
    };
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
  Map<String, dynamic> toJson() {
    return {'total': total, 'sugar': sugar};
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
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'saturated': saturated,
      'monounsaturated': monounsaturated,
      'polyunsaturated': polyunsaturated,
    };
  }
}
