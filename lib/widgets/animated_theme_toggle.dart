import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedThemeToggle extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onToggle;
  final Duration duration;

  const AnimatedThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<Color?> _iconColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.isDarkMode ? 1.0 : 0.0,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 180.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.6), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0.6, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF1C1259), // Original color for light mode
      end: const Color(0xFF6A5ACD), // Slateblue for dark mode
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconColorAnimation = ColorTween(
      begin: Colors.black,
      end: const Color(0xFF6A5ACD), // Slateblue for dark mode
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != oldWidget.isDarkMode) {
      if (widget.isDarkMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isDarkMode) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        widget.onToggle(!widget.isDarkMode);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: 60.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: _colorAnimation.value!.withAlpha(77), // 0.3 opacity
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Track
                Container(
                  width: 60.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.wb_sunny_rounded,
                          color:
                              widget.isDarkMode
                                  ? Colors.white.withAlpha(128) // 0.5 opacity
                                  : Colors.white,
                          size: 16.sp,
                        ),
                        Icon(
                          Icons.nightlight_round,
                          color:
                              widget.isDarkMode
                                  ? const Color(
                                    0xFFFFD700,
                                  ) // Gold color for better visibility
                                  : Colors.black.withAlpha(128), // 0.5 opacity
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                // Thumb
                Positioned(
                  left: _animationController.value * 30.w,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159 / 180,
                      child: Container(
                        width: 30.h,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26), // 0.1 opacity
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            widget.isDarkMode
                                ? Icons.nightlight_round
                                : Icons.wb_sunny_rounded,
                            color: _iconColorAnimation.value,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
