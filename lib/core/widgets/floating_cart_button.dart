import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FloatingCartButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const FloatingCartButton({
    super.key,
    required this.onTap,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.cartButtonBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.shopping_bag_outlined,
          color: AppColors.cartButtonIcon,
          size: size * 0.5,
        ),
      ),
    );
  }
}
