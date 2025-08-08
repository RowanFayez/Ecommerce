import 'package:flutter/material.dart';
import 'package:taskaia/core/theme/app_colors.dart';
import 'package:taskaia/core/theme/theme_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showThemeToggle;
  final VoidCallback? onLogout;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showThemeToggle = false,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeManager = ThemeManager();

    return AppBar(
      leading: leading,
      title: title != null ? Text(title!) : null,
      actions: [
        ...?actions,
        if (showThemeToggle)
          Switch(
            value: themeManager.isDarkMode,
            onChanged: (value) {
              themeManager.toggleTheme();
            },
            activeColor: AppColors.primary,
          ),
        if (onLogout != null)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Logout',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
