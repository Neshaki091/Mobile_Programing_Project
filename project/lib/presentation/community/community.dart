import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/community_repository.dart';
import '../../routes/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import '../../widgets/appBar_widget.dart';

class CommunityScreen extends StatefulWidget {
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final AuthRepository _authRepository = AuthRepository(); // <-- Tạo bên trong
  late final String currentUserId;
  final CommunityRepository _communityRepo = CommunityRepository();
  List<UserProfile> _allUsers = [];
  List<UserProfile> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();
  int currentIndex = 4;
  @override
  void initState() {
    super.initState();
    currentUserId = _authRepository.currentUser?.uid ?? '';
    _loadUsers();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadUsers() async {
    final users = await _communityRepo.getAllUsers();
    setState(() {
      _allUsers = users.where((u) => u.uid != currentUserId).toList();
      _filteredUsers = _allUsers;
    });
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
        Navigator.pushNamed(context, AppRoutes.workout);
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.journey);
        break;
      case 4:
        break;
      case 5:
        Navigator.pushNamed(context, AppRoutes.profile);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers =
          _allUsers
              .where((user) => user.name.toLowerCase().contains(query))
              .toList();
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
      appBar: AppBar(title: const Text('Cộng đồng')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm người dùng...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _filteredUsers.isEmpty
                    ? const Center(child: Text('Không tìm thấy người dùng'))
                    : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                user.avatarUrl.isNotEmpty
                                    ? NetworkImage(user.avatarUrl)
                                    : null,
                            child:
                                user.avatarUrl.isEmpty
                                    ? Icon(Icons.person)
                                    : null,
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            icon: Icon(Icons.chat),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.chat,
                                arguments: {
                                  'currentUser': _authRepository.currentUser,
                                  'friend': user,
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
