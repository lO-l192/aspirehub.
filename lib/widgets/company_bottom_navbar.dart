import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompanyBottomNavbar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const CompanyBottomNavbar({
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
          width: 80.w,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
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
                ],
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
    // Define icon paths
    const String homeIconPath = 'assets/images/Vector.svg';
    const String messageIconPath = 'assets/images/mail_icon.svg';
    const String candidatesIconPath = 'assets/images/cond_icon.svg';
    const String settingsIconPath = 'assets/images/Vector (1).svg';

    double iconSize = 24.sp; // Smaller size for better fit

    switch (index) {
      case 0: // Home
        return SvgPicture.asset(
          homeIconPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            isSelected ? selectedColor : unselectedColor,
            BlendMode.srcIn,
          ),
        );
      case 1: // Messages
        return SvgPicture.asset(
          messageIconPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            isSelected ? selectedColor : unselectedColor,
            BlendMode.srcIn,
          ),
        );
      case 2: // Candidates
        return SvgPicture.asset(
          candidatesIconPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            isSelected ? selectedColor : unselectedColor,
            BlendMode.srcIn,
          ),
        );
      case 3: // Settings
        return SvgPicture.asset(
          settingsIconPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            isSelected ? selectedColor : unselectedColor,
            BlendMode.srcIn,
          ),
        );
      default:
        return SvgPicture.asset(
          homeIconPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            isSelected ? selectedColor : unselectedColor,
            BlendMode.srcIn,
          ),
        );
    }
  }
}
