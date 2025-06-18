import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/learner_viewmodel.dart';
import '../models/user_model.dart';
import 'detail_user_screen.dart';

class LearnerScreen extends StatefulWidget {
  const LearnerScreen({super.key});

  @override
  State<LearnerScreen> createState() => _LearnerScreenState();
}

class _LearnerScreenState extends State<LearnerScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LearnerViewModel>(context, listen: false).loadLearners();
    });

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách người dùng'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<LearnerViewModel>(
          builder: (context, learnerVM, child) {
            if (learnerVM.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = learnerVM.learners.where((user) {
              final name = user.name.toLowerCase();
              final email = user.email.toLowerCase();
              return name.contains(_searchText) || email.contains(_searchText);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo tên hoặc email...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: users.isEmpty
                      ? const Center(child: Text('Không có người dùng nào.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: user.avatarUrl.isNotEmpty
                                      ? NetworkImage(user.avatarUrl)
                                      : null,
                                  child: user.avatarUrl.isEmpty
                                      ? const Icon(Icons.person, size: 30)
                                      : null,
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                                    size: 18, color: Colors.grey),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailUserScreen(user: user),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
