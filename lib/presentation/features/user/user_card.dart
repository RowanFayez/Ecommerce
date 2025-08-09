import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/user.dart';
import '../../../core/di/injection.dart';
import '../../../data/datasources/api_client.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({super.key, required this.user});

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
                    final api = getIt<ApiClient>();
                    final updated = await api.updateUser(
                      user.id,
                      User(
                        id: user.id,
                        email: user.email,
                        username: user.username,
                        password: user.password,
                        name: Name(
                          firstname: '${user.name.firstname}*',
                          lastname: user.name.lastname,
                        ),
                        phone: user.phone,
                        address: user.address,
                      ),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Updated: ${updated.name.firstname}')),
                      );
                    }
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Quick Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
