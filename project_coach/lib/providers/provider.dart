import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/nutrition_viewmodel.dart';
import '../viewmodels/workout_viewmodel.dart';
import '../viewmodels/learner_viewmodel.dart'; // Nếu có dùng LearnerViewModel

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ChangeNotifierProvider(create: (_) => WorkoutViewModel()),
  ChangeNotifierProvider(create: (_) => NutritionViewModel()),
  ChangeNotifierProvider(create: (_) => LearnerViewModel()), // có thể bỏ nếu không dùng
];
