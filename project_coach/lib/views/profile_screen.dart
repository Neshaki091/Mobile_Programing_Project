import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;

  late bool _isMale;
  late UserProfile _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;

    _nameController = TextEditingController(text: _currentUser.name);
    _emailController = TextEditingController(text: _currentUser.email);
    _heightController = TextEditingController(text: _currentUser.height.toString());
    _weightController = TextEditingController(text: _currentUser.weight.toString());
    _ageController = TextEditingController(text: _currentUser.age?.toString() ?? '');
    _isMale = _currentUser.isMale;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    final updatedUser = _currentUser.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      height: double.tryParse(_heightController.text.trim()) ?? _currentUser.height,
      weight: double.tryParse(_weightController.text.trim()) ?? _currentUser.weight,
      age: int.tryParse(_ageController.text.trim()) ?? _currentUser.age,
      isMale: _isMale,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.uid)
          .update(updatedUser.toMap());

      setState(() {
        _currentUser = updatedUser;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hồ sơ thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu: $e')),
      );
    }
  }

  Widget _buildEditableRow(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          // const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              textAlign: TextAlign.right,
              enabled: _isEditing,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Giới tính', style: TextStyle(fontWeight: FontWeight.w500)),
          _isEditing
              ? Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isMale,
                      onChanged: (value) => setState(() => _isMale = value!),
                    ),
                    const Text('Nam'),
                    Radio<bool>(
                      value: false,
                      groupValue: _isMale,
                      onChanged: (value) => setState(() => _isMale = value!),
                    ),
                    const Text('Nữ'),
                  ],
                )
              : Text(_isMale ? 'Nam' : 'Nữ', style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Chỉnh sửa hồ sơ' : 'Hồ sơ cá nhân'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveProfile : _toggleEdit,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _currentUser.avatarUrl.isNotEmpty
                    ? NetworkImage(_currentUser.avatarUrl)
                    : null,
                child: _currentUser.avatarUrl.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildEditableRow('Tên', _nameController),
                      _buildEditableRow('Email', _emailController),
                      const Divider(),
                      _buildEditableRow('Chiều cao (cm)', _heightController, inputType: TextInputType.number),
                      _buildEditableRow('Cân nặng (kg)', _weightController, inputType: TextInputType.number),
                      _buildEditableRow('Tuổi', _ageController, inputType: TextInputType.number),
                      const SizedBox(height: 8),
                      _buildGenderSelector(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thống kê cá nhân', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      _buildInfoRow('Số bạn bè', '${_currentUser.friends.length}'),
                      _buildInfoRow('Bài tập yêu thích', '${_currentUser.favorites.length}'),
                      _buildInfoRow('Bài tập của tôi', '${_currentUser.myWorkouts.length}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lịch thông báo', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.sunny),
                        title: Text(
                          'Buổi sáng: ${_currentUser.morningHour}h${_currentUser.morningMinute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.nightlight_round),
                        title: Text(
                          'Buổi chiều: ${_currentUser.afternoonHour}h${_currentUser.afternoonMinute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
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
