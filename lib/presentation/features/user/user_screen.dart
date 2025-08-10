import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../data/datasources/api_client.dart';
import '../../../data/models/user.dart';
import 'user_card.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _api = getIt<ApiClient>();
  bool _isLoading = true;
  String? _error;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _api.getUsers();
      setState(() {
        _users = data;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onUserUpdated(User updated) {
    final index = _users.indexWhere((u) => u.id == updated.id);
    if (index != -1) {
      setState(() {
        _users[index] = updated;
      });
    } else {
      // If not in the list, re-fetch to stay consistent
      _fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchUsers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_users.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchUsers,
        child: ListView(
          children: const [
            SizedBox(height: 200),
            Center(child: Text('No users found')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchUsers,
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return UserCard(
            user: user,
            onUpdated: _onUserUpdated,
          );
        },
      ),
    );
  }
}
