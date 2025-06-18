import 'package:flutter/material.dart';
import '../models/user_model.dart';

class DetailUserScreen extends StatelessWidget {
  final UserProfile user;

  const DetailUserScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết người dùng'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : null,
                  child: user.avatarUrl.isEmpty
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Tên
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Thông tin chi tiết
              _buildInfoCard(
                icon: Icons.height,
                label: 'Chiều cao',
                value: '${user.height} cm',
              ),
              _buildInfoCard(
                icon: Icons.monitor_weight,
                label: 'Cân nặng',
                value: '${user.weight} kg',
              ),
              if (user.age != null)
                _buildInfoCard(
                  icon: Icons.calendar_today,
                  label: 'Tuổi',
                  value: '${user.age}',
                ),
              _buildInfoCard(
                icon: Icons.person_outline,
                label: 'Giới tính',
                value: user.isMale ? 'Nam' : 'Nữ',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(label),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
