import 'package:flutter/material.dart';
import '..//exercises/exercises_screen.dart';
import 'workout_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(const MyApp());
}

// Widget gốc khởi chạy app
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: YAppWithTab(), // Không còn tham số initialTabIndex
    );
  }
}

// Widget điều hướng có 5 tab (Home, Exercises, Workouts, Journey, Profile)
class YAppWithTab extends StatefulWidget {
  const YAppWithTab({super.key});

  @override
  State<YAppWithTab> createState() => _YAppWithTabState();
}

class _YAppWithTabState extends State<YAppWithTab> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2; // Mặc định mở tab Workouts
  }

  static final List<Widget> _pages = <Widget>[
    HomeScreen(),
    ExercisesScreen(),
    WorkoutScreen(),
    JourneyScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(""), centerTitle: true),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Exercises"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Workouts"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Journey"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,        
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Trang chủ'));
  }
}

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Hành trình của bạn'));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Hồ sơ cá nhân'));
  }
}

// Trang "Home" với thanh tìm kiếm + bộ lọc
class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ExercisesScreen> {
  TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> items = [
    {
      "title": "Barbell Row",
      "subtitle": "Lưng, Cơ xô, Lưng trên, Cơ tay trước",
      "image": "assets/Barbell Row.png",
      "level": "Medium",
    },
    {
      "title": "Barbell Bench Press",
      "subtitle": "Ngực, Vai, Cơ tay sau",
      "image": "assets/Barbell Bench Press.png",
      "level": "Medium",
    },
    {
      "title": "Dumbbell Bicep Curls",
      "subtitle": "Tay trước",
      "image": "assets/Dumbbell Bicep Curls.png",
      "level": "Easy",
    },
    {
      "title": "Deadlift",
      "subtitle": "Cơ đùi sau, Cơ mông, Lưng, Cơ core",
      "image": "assets/Deadlift.png",
      "level": "Hard",
    },
    {
      "title": "Hip Thrust",
      "subtitle": "Cơ mông, Cơ đùi sau",
      "image": "assets/Hip Thrust.png",
      "level": "Easy",
    },
    {
      "title": "Lat Pulldown",
      "subtitle": "Lưng, Cơ xô, Cơ tay trước",
      "image": "assets/Lat Pulldown.png",
      "level": "Medium-Easy",
    },
    {
      "title": "Leg Press",
      "subtitle": "Cơ đùi trước, Cơ mông, Cơ đùi sau",
      "image": "assets/Leg Press.png",
      "level": "Medium-Easy",
    },
  ];

  List<Map<String, String>> filteredItems = [];
  List<String> selectedFilters = [];


  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void _filterItems() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      filteredItems = items.where((item) {
        final title = item['title']?.toLowerCase() ?? '';
        final subtitle = item['subtitle']?.toLowerCase() ?? '';

        // Kiểm tra theo từ khóa tìm kiếm
        bool matchesSearch = title.contains(query) || subtitle.contains(query);

        // Kiểm tra theo bộ lọc nếu có
        bool matchesFilter = selectedFilters.isEmpty || selectedFilters.any((filter) =>
        title.contains(filter.toLowerCase()) || subtitle.contains(filter.toLowerCase())
        );

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }




  void _openFilterDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(selectedFilters: selectedFilters);
      },
    );

    if (result != null) {
      setState(() {
        selectedFilters = result;
      });
      _filterItems();
    } else {
      setState(() {
        selectedFilters = [];
        _searchController.clear(); // nếu muốn reset cả tìm kiếm
        filteredItems = items;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chọn bài tập phù hợp"),centerTitle: true,),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _filterItems(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _openFilterDialog,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final level = item["level"] ?? "Easy"; // Mặc định là Easy

                // Đổi màu theo level
                Color levelColor;
                switch (level) {
                  case "Medium":
                    levelColor = Colors.orange;
                    break;
                  case "Hard":
                    levelColor = Colors.red;
                    break;
                  case "Medium-Easy":
                    levelColor = Colors.blue;
                    break;
                  default:
                    levelColor = Colors.green;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: Image.asset(
                        item["image"]!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                        },
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"]!,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item["subtitle"]!,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.flag, color: levelColor, size: 16),
                              SizedBox(width: 4),
                              Text(
                                level,
                                style: TextStyle(
                                  color: levelColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmptyPage(
                              title: item["title"]!,
                              subtitle: item["subtitle"]!,
                              image: item["image"]!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}

// Trang trống khi click vào một mục

// Hộp thoại bộ lọc
class FilterDialog extends StatefulWidget {
  final List<String> selectedFilters;

  FilterDialog({required this.selectedFilters});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<FilterOption> filterOptions = [
    FilterOption("Lưng trên"),
    FilterOption("Cơ xô"),
    FilterOption("Cơ tay Sau"),
    FilterOption("Vai"),
    FilterOption("Ngực"),
    FilterOption("Cơ tay trước"),
    FilterOption("Cơ đùi trước"),
  ];

  @override
  void initState() {
    super.initState();
    for (var option in filterOptions) {
      option.isSelected = widget.selectedFilters.contains(option.name);
    }
  }

  void _applyFilters() {
    Navigator.of(context).pop(
        filterOptions.where((f) => f.isSelected).map<String>((f) => f.name).toList()
    );

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Chọn bộ lọc"),
      content: Wrap(
        spacing: 8,
        children: filterOptions.map((option) {
          return FilterChip(
            label: Text(option.name),
            selected: option.isSelected,
            onSelected: (selected) {
              setState(() {
                option.isSelected = selected;
              });
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: Text("Áp dụng"),
        ),
      ],
    );
  }
}

// Màn hình placeholder cho các tab khác
class OtherScreen extends StatelessWidget {
  final String title;
  OtherScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: TextStyle(fontSize: 24)),
    );
  }
}

// Model bộ lọc
class FilterOption {
  final String name;
  bool isSelected;

  FilterOption(this.name, {this.isSelected = false});
}
