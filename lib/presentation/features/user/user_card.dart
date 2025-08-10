import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/user.dart';
// import '../../../core/di/injection.dart';
// import '../../../data/datasources/api_client.dart';
import 'edit_user_screen.dart';

class UserCard extends StatelessWidget {
  final User user;
  final void Function(User updated)? onUpdated;
  const UserCard({super.key, required this.user, this.onUpdated});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.productBackground,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.username,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Email: ${user.email}'),
            Text('Name: ${user.name.firstname} ${user.name.lastname}'),
            Text('Phone: ${user.phone}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final updated = await Navigator.of(context).push<User>(
                      MaterialPageRoute(
                        builder: (_) => EditUserScreen(user: user),
                      ),
                    );
                    if (updated != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User updated')),
                      );
                      onUpdated?.call(updated);
                    }
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
