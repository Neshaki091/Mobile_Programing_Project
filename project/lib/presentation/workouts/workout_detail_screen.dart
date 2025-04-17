import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Widget AppBar dùng lại với 3 nút và thêm nút quay lại
class CustomWorkoutAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackToWorkout;
  final String? currentTab; // Tab hiện tại để thêm viền
  final String subtitle; // Added to fix the missing reference
  final String image; // Added to fix the missing reference

  const CustomWorkoutAppBar({
    super.key,
    required this.title,
    this.showBackToWorkout = false,
    this.currentTab,
    required this.subtitle, // Added this to align with FavoriteScreen's parameters
    required this.image, // Added this to align with FavoriteScreen's parameters
  });

  @override
  Size get preferredSize => const Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading:
          showBackToWorkout
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // ✅ Quay lại trang trước
                },
              )
              : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          currentTab == 'exercise'
                              ? const Color.fromARGB(255, 33, 1, 113)
                              : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentTab != 'exercise') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Exercise_Screen(),
                          ), // Make sure Exercise_Screen is defined
                        );
                      }
                    },
                    child: const Text("Bài tập luyện"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          currentTab == 'favorite'
                              ? const Color.fromARGB(255, 33, 1, 113)
                              : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentTab != 'favorite') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => FavoriteScreen(
                                  title: title,
                                  subtitle: subtitle,
                                  image: image,
                                ),
                          ),
                        );
                      }
                    },
                    child: const Text("Bài tập ưa thích"),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          currentTab == 'my'
                              ? const Color.fromARGB(255, 33, 1, 113)
                              : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentTab != 'my') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyExerciseScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text("Bài tập của tôi"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Trang chính Workouts
class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomWorkoutAppBar(
        title: "Workouts",
        subtitle: "",
        image: "",
      ),
      body: const Center(
        child: Text("Đây là trang Workouts", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

// Trang: Bài tập luyện

class Exercise_Screen extends StatelessWidget {
  Exercise_Screen({super.key});

  Future<List<String>> fetchImageUrls() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('workout').get();
    return snapshot.docs
        .map((doc) => doc['imageUrl'] as String? ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  final List<String> rowTitles = ['Khởi động', 'Ngực', 'Lưng'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomWorkoutAppBar(
        title: "Bài tập luyện",
        subtitle: "",
        image: "",
        showBackToWorkout: true,
        currentTab: 'exercise',
      ),
      body: FutureBuilder<List<String>>(
        future: fetchImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có ảnh nào.'));
          }

          final imageUrls = snapshot.data!;
          final rowCount = (imageUrls.length / 3).ceil();

          return ListView.builder(
            itemCount: rowCount,
            itemBuilder: (context, rowIndex) {
              final start = rowIndex * 3;
              final end = (start + 3).clamp(0, imageUrls.length);
              final rowImages = imageUrls.sublist(start, end);
              final title =
                  rowIndex < rowTitles.length
                      ? rowTitles[rowIndex]
                      : 'Nhóm khác';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề hàng
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Hàng ảnh
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children:
                          rowImages.map((url) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    url,
                                    fit:
                                        BoxFit.contain, // ✅ Hiển thị đầy đủ ảnh
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Trang: Bài tập ưa thích
class FavoriteScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  const FavoriteScreen({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: $title", style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text("Subtitle: $subtitle", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Image.asset(image), // Assuming image asset is available
          ],
        ),
      ),
    );
  }
}

// Trang: Bài tập của tôi
class MyExerciseScreen extends StatefulWidget {
  const MyExerciseScreen({super.key});

  @override
  State<MyExerciseScreen> createState() => _MyExerciseScreenState();
}

class _MyExerciseScreenState extends State<MyExerciseScreen> {
  List<Map<String, dynamic>> selectedExercises = [];

  Future<List<Map<String, dynamic>>> fetchExercises() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('workout').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  void _showExerciseDialog() async {
    final exercises = await fetchExercises();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Chọn bài tập"),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    leading:
                        exercise['imageUrl'] != null
                            ? Image.network(
                              exercise['imageUrl'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.fitness_center),
                    title: Text(exercise['title'] ?? 'Không có tên'),
                    onTap: () {
                      setState(() {
                        // Tránh thêm trùng
                        if (!selectedExercises.any(
                          (e) => e['id'] == exercise['id'],
                        )) {
                          selectedExercises.add(exercise);
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomWorkoutAppBar(
        title: "Bài tập của tôi",
        subtitle: "",
        image: "",
        showBackToWorkout: true,
        currentTab: 'my',
      ),
      body:
          selectedExercises.isEmpty
              ? const Center(child: Text("Chưa chọn bài tập nào."))
              : ListView.builder(
                itemCount: selectedExercises.length,
                itemBuilder: (context, index) {
                  final exercise = selectedExercises[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading:
                          exercise['imageUrl'] != null
                              ? Image.network(
                                exercise['imageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.image),
                      title: Text(exercise['title'] ?? 'Không có tiêu đề'),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showExerciseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
