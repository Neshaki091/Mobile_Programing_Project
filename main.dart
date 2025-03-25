import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomeScreen(),
    OtherScreen(title: "Exercises"),
    OtherScreen(title: "Workouts"),
    OtherScreen(title: "Journey"),
    OtherScreen(title: "Profile"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("BÀI TẬP")),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Exercises"),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: "Workouts"),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Journey"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

// Trang "Home" với thanh tìm kiếm + bộ lọc
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> items = List.generate(100, (index) => "Item $index");
  List<String> filteredItems = [];
  List<String> selectedFilters = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void _filterItems() {
    setState(() {
      filteredItems = items.where((item) {
        final searchMatch = item.toLowerCase().contains(_searchController.text.toLowerCase());
        final filterMatch = selectedFilters.isEmpty || selectedFilters.any((filter) => item.contains(filter));
        return searchMatch && filterMatch;
      }).toList();
    });
  }

  void _openFilterDialog() async {
    List<String> newFilters = await showDialog(
      context: context,
      builder: (context) => FilterDialog(selectedFilters: selectedFilters),
    );
    if (newFilters != null) {
      setState(() {
        selectedFilters = newFilters;
        _filterItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              return ListTile(
                title: Text(filteredItems[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Hộp thoại bộ lọc
class FilterDialog extends StatefulWidget {
  final List<String> selectedFilters;

  FilterDialog({required this.selectedFilters});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<FilterOption> filterOptions = [
    FilterOption("Tạ đơn"),
    FilterOption("Xà đơn"),
    FilterOption("Máy"),
    FilterOption("Bụng"),
    FilterOption("Ngực"),
  ];

  @override
  void initState() {
    super.initState();
    for (var option in filterOptions) {
      option.isSelected = widget.selectedFilters.contains(option.name);
    }
  }

  void _applyFilters() {
    Navigator.of(context).pop(filterOptions.where((f) => f.isSelected).map((f) => f.name).toList());
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
        TextButton(onPressed: () => Navigator.of(context).pop([]), child: Text("Hủy")),
        ElevatedButton(onPressed: _applyFilters, child: Text("Áp dụng")),
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
