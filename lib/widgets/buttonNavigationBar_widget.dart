import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aspirehub3/widgets/custom_nav_icons.dart';

class NavBar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const NavBar({
    super.key,
    required this.onItemSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 68.h, // Fixed height to prevent overflow
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 5.r,
                offset: Offset(0, -2.h),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  navItem(0, context),
                  navItem(1, context),
                  navItem(2, context),
                  navItem(3, context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget navItem(int index, BuildContext context) {
    final themeProvider = Theme.of(context);
    final isDarkMode = themeProvider.brightness == Brightness.dark;

    final selectedColor =
        isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Dark blue for light mode

    final unselectedColor =
        themeProvider.bottomNavigationBarTheme.unselectedItemColor ??
        Colors.grey;
    final isSelected = selectedIndex == index;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Selected indicator dot
        Positioned(
          top: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isSelected ? 3.h : 0,
            width: isSelected ? 20.w : 0,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
        SizedBox(
          width: 75.w,
          height: 55.h,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15.r),
              onTap: () {
                if (index != selectedIndex) {
                  // Add haptic feedback for better user experience
                  HapticFeedback.lightImpact();
                  onItemSelected(index);
                }
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? selectedColor.withAlpha(26)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: _getIcon(
                    index,
                    isSelected,
                    selectedColor,
                    unselectedColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getIcon(
    int index,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
  ) {
    switch (index) {
      case 0: // Dashboard
        return CustomNavIcons.home(
          isSelected: isSelected,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        );
      case 1: // Statistics
        return CustomNavIcons.lightbulb(
          isSelected: isSelected,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        );
      case 2: // Profile
        return CustomNavIcons.person(
          isSelected: isSelected,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        );
      case 3: // Settings
        return CustomNavIcons.settings(
          isSelected: isSelected,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        );
      default:
        return CustomNavIcons.home(
          isSelected: isSelected,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        );
    }
  }
}
