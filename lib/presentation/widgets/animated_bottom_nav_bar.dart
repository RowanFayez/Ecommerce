import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/utils/responsive_utils.dart';

double? lerpDouble(num a, num b, double t) => a + (b - a) * t;

class AnimatedBottomNavBarItem {
  final IconData icon;
  final String label;
  const AnimatedBottomNavBarItem({required this.icon, required this.label});
}

class AnimatedBottomNavBar extends StatefulWidget {
  final List<AnimatedBottomNavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Duration duration;

  const AnimatedBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.duration = const Duration(milliseconds: 350),
  }) : assert(items.length >= 2);

  @override
  State<AnimatedBottomNavBar> createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curve;
  int _oldIndex = 0;

  @override
  void initState() {
    super.initState();
    _oldIndex = widget.currentIndex;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void didUpdateWidget(covariant AnimatedBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _oldIndex = oldWidget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ??
        (isDark ? AppColors.primary : AppColors.primary);
    final surface = isDark ? AppColors.darkSurface : AppColors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = width / widget.items.length;
        final height = ResponsiveUtils.getResponsiveSpacing(
          context,
          66,
        );
        final circleSize = ResponsiveUtils.getResponsiveSpacing(context, 44);

        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background with moving notch
              AnimatedBuilder(
                animation: _curve,
                builder: (context, child) {
                  final t = _curve.value;
                  final from = _oldIndex * itemWidth + itemWidth / 2;
                  final to = widget.currentIndex * itemWidth + itemWidth / 2;
                  final notchCenterX = lerpDouble(from, to, t)!;
                  return ClipPath(
                    clipper: _NavBarNotchClipper(
                      notchCenterX: notchCenterX,
                      notchRadius: circleSize / 2 + 8,
                      cornerRadius: 18,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bg,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 12,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Floating circle for the selected icon
              AnimatedBuilder(
                animation: _curve,
                builder: (context, _) {
                  final t = _curve.value;
                  final from =
                      _oldIndex * itemWidth + (itemWidth - circleSize) / 2;
                  final to = widget.currentIndex * itemWidth +
                      (itemWidth - circleSize) / 2;
                  final left = lerpDouble(from, to, t)!;
                  return Positioned(
                    top: -circleSize / 2,
                    left: left,
                    width: circleSize,
                    height: circleSize,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: surface,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          widget.items[widget.currentIndex].icon,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Items row
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          ResponsiveUtils.getResponsiveSpacing(context, 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < widget.items.length; i++)
                          _NavItem(
                            item: widget.items[i],
                            isSelected: i == widget.currentIndex,
                            onTap: () => widget.onTap(i),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final AnimatedBottomNavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavItem(
      {required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(isSelected ? 1 : 0.8);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: color),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  color: color,
                  fontSize: AppDimensions.fontSmall,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarNotchClipper extends CustomClipper<Path> {
  final double notchCenterX;
  final double notchRadius;
  final double cornerRadius;
  const _NavBarNotchClipper({
    required this.notchCenterX,
    required this.notchRadius,
    required this.cornerRadius,
  });

  @override
  Path getClip(Size size) {
    // base rounded rect
    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: Radius.circular(cornerRadius),
      topRight: Radius.circular(cornerRadius),
    );
    final base = Path()..addRRect(rect);

    // notch circle to subtract
    final circle = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(notchCenterX, 0),
        radius: notchRadius,
      ));

    return Path.combine(PathOperation.difference, base, circle);
  }

  @override
  bool shouldReclip(covariant _NavBarNotchClipper oldClipper) {
    return oldClipper.notchCenterX != notchCenterX ||
        oldClipper.notchRadius != notchRadius ||
        oldClipper.cornerRadius != cornerRadius;
  }
}
