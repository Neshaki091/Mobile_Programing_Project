import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/workout_widget.dart';
import '../../widgets/appBar_widget.dart';
import '../../routes/app_routes.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 1) {
        Provider.of<WorkoutProvider>(context, listen: false).loadFavorites();
      }
    });

    Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
    Provider.of<WorkoutProvider>(context, listen: false).loadMyWorkouts();
  }

  void onTap(int index) {
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.exercise);
        break;
      case 2:
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.journey);
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.community);
        break;
      case 5:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final workouts = workoutProvider.workouts;
    final myWorkouts = workoutProvider.myWorkouts;
    final favoriteWorkouts = workoutProvider.favoriteWorkouts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài tập'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tất cả bài tập'),
            Tab(text: 'Bài tập yêu thích'),
            Tab(text: 'Bài tập của tôi'),
          ],
        ),
      ),
      body:
          workouts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Tất cả bài tập
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildWorkoutGroup('Tay', workouts, workoutProvider),
                        buildWorkoutGroup('Chân', workouts, workoutProvider),
                        buildWorkoutGroup('Lưng', workouts, workoutProvider),
                        buildWorkoutGroup('Bụng', workouts, workoutProvider),
                        buildWorkoutGroup('Ngực', workouts, workoutProvider),
                        buildWorkoutGroup('Vai', workouts, workoutProvider),
                      ],
                    ),
                  ),
                  // Tab 2: Bài tập yêu thích
                  ListView.builder(
                    itemCount: favoriteWorkouts.length,
                    itemBuilder: (context, index) {
                      return ExerciseItemWidget(
                        workout: favoriteWorkouts[index],
                        onRemoveFromMyWorkouts: () {
                          workoutProvider.removeFromFavoriteWorkouts(
                            favoriteWorkouts[index],
                          );
                        },
                      );
                    },
                  ),
                  // Tab 3: Bài tập của tôi
                  ListView.builder(
                    itemCount: myWorkouts.length,
                    itemBuilder: (context, index) {
                      return ExerciseItemWidget(
                        workout: myWorkouts[index],
                        onRemoveFromMyWorkouts: () {
                          workoutProvider.removeFromMyWorkouts(
                            myWorkouts[index],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
      floatingActionButton:
          _tabController.index == 2
              ? FloatingActionButton(
                onPressed: () {
                  _showAddWorkoutDialog(workoutProvider);
                },
                child: const Icon(Icons.add),
                tooltip: 'Thêm bài tập',
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAddWorkoutDialog(WorkoutProvider workoutProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn bài tập'),
          content: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: workoutProvider.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutProvider.workouts[index];
                return ListTile(
                  title: Text(workout.name),
                  onTap: () {
                    workoutProvider.addToMyWorkouts(workout);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildWorkoutGroup(
    String group,
    List<dynamic> workouts,
    WorkoutProvider workoutProvider,
  ) {
    final groupWorkouts =
        workouts
            .where(
              (workout) =>
                  workout.muscleGroup != null && workout.muscleGroup == group,
            )
            .toList();

    if (groupWorkouts.isEmpty) return const SizedBox();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              group,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  groupWorkouts.map((workout) {
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: WorkoutItemWidget(
                        workout: workout,
                        onAddToMyWorkouts: () {
                          workoutProvider.addToMyWorkouts(workout);
                        },
                        onAddToFavorites: () {
                          workoutProvider.addToFavoriteWorkouts(workout);
                        },
                        onRemoveFromFavorites: () {
                          workoutProvider.removeFromFavoriteWorkouts(workout);
                        },
                        isFavorite: workoutProvider.isFavorite(workout),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
