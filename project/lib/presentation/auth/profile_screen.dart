import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  final AuthRepository authRepo;

  const ProfileScreen({Key? key, required this.authRepo}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  List<String> _selectedDays = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = widget.authRepo.currentUser?.uid;
    if (uid == null) return;

    final profile = await widget.authRepo.getUserProfile(uid);
    if (profile != null) {
      _nameController.text = profile.name;
      _weightController.text = profile.weight.toString();
      _heightController.text = profile.height.toString();
      _selectedDays = profile.schedule;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', profile.name);
      await prefs.setDouble('weight', profile.weight);
      await prefs.setDouble('height', profile.height);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    final uid = widget.authRepo.currentUser?.uid;
    if (uid == null) return;

    final profile = UserProfile(
      uid: uid,
      name: _nameController.text,
      email: widget.authRepo.currentUser?.email ?? '',
      weight: double.tryParse(_weightController.text) ?? 0,
      height: double.tryParse(_heightController.text) ?? 0,
      schedule: _selectedDays,
    );

    await widget.authRepo.updateUserProfile(profile);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', profile.name);
    await prefs.setDouble('weight', profile.weight);
    await prefs.setDouble('height', profile.height);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Thông tin đã được lưu!")));
  }

  Widget _buildDaySelector(String day) {
    final isSelected = _selectedDays.contains(day);
    return ChoiceChip(
      label: Text(day),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedDays.add(day);
          } else {
            _selectedDays.remove(day);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ người dùng'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed:
                () => {Navigator.pushReplacementNamed(context, AppRoutes.home)},
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Họ tên'),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Cân nặng (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Chiều cao (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text(
              "Lịch tập luyện",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children:
                  [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ].map((day) => _buildDaySelector(day)).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProfile, child: Text("Lưu")),
          ],
        ),
      ),
    );
  }
}
