import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/workout_widget.dart'; // Ensure this import exists
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
        break;
      case 4:
        Navigator.pushNamed(context, AppRoutes.community);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Lắng nghe sự thay đổi của tab để cập nhật currentIndex
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });

    Provider.of<WorkoutProvider>(context, listen: false).loadWorkouts();
    Provider.of<WorkoutProvider>(context, listen: false).loadMyWorkouts();
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
                  ), // Tab Tất cả bài tập
                  // Tab Bài tập yêu thích
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          workouts.map((workout) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: WorkoutItemWidget(workout: workout),
                            );
                          }).toList(),
                    ),
                  ),
                  // Tab Bài tập của tôi
                  ListView.builder(
                    itemCount: myWorkouts.length,
                    itemBuilder: (context, index) {
                      return ExerciseItemWidget(
                        workout: myWorkouts[index],
                        onRemoveFromMyWorkouts: () {
                          // Xóa bài tập khỏi "Bài tập của tôi"
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
          _tabController.index ==
                  2 // Chỉ hiển thị khi ở Tab "Bài tập của tôi"
              ? FloatingActionButton(
                onPressed: () {
                  _showAddWorkoutDialog(workoutProvider);
                },
                child: const Icon(Icons.add),
                tooltip: 'Thêm bài tập',
              )
              : null, // Nếu không phải tab "Bài tập của tôi", không hiển thị FAB
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Nút ở dưới bên trái
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
                    Navigator.pop(context); // Đóng dialog sau khi chọn
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

    if (groupWorkouts.isEmpty) return SizedBox();

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
