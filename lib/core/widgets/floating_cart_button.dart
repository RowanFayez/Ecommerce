import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FloatingCartButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingCartButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.cartButtonBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.shopping_bag_outlined,
          color: AppColors.cartButtonIcon,
          size: 24,
        ),
      ),
    );
  }
}
