import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../data/datasources/api_client.dart';
import '../../../data/models/user.dart';
import 'user_card.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = getIt<ApiClient>();
    return FutureBuilder<List<User>>(
      future: apiClient.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return UserCard(user: user);
          },
        );
      },
    );
  }
}
