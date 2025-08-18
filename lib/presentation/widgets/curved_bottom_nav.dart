import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CurvedBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const CurvedBottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Icon buildIcon(IconData data, int i) => Icon(
          data,
          size: 24,
          color: i == index ? AppColors.primary : Colors.white,
        );

    // Only Home, Favorites (center), and Profile
    final items = <Widget>[
      buildIcon(Icons.home, 0),
      buildIcon(Icons.favorite, 1), // center heart
      buildIcon(Icons.person, 2),
    ];

    return CurvedNavigationBar(
      index: index,
      height: 54,
      items: items,
      backgroundColor: Colors.transparent,
      color: AppColors.primary,
      buttonBackgroundColor: Colors.white,
      animationCurve: Curves.easeOutCubic,
      animationDuration: const Duration(milliseconds: 250),
      onTap: onTap,
      letIndexChange: (_) => true,
    );
  }
}
