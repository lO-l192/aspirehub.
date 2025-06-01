import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/dash_board_screen.dart';
import 'package:aspirehub3/screens/main_screen.dart';
import 'package:aspirehub3/screens/previous_screen.dart';
import 'package:aspirehub3/screens/profile_screen.dart';
import 'package:aspirehub3/screens/statics_screen.dart';
import 'package:aspirehub3/widgets/animated_theme_toggle.dart';
import 'package:aspirehub3/widgets/buttonNavigationBar_widget.dart';
import 'package:aspirehub3/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:aspirehub3/Models/controller/profile_controller.dart';

class SettingScreen extends StatefulWidget {
  final bool isInTabView;

  const SettingScreen({super.key, this.isInTabView = false});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
    with SingleTickerProviderStateMixin {
  final int _selectedIndex = 3;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: AnimatedThemeToggle(
              isDarkMode: themeProvider.isDarkMode,
              onToggle: (isDark) {
                themeProvider.toggleTheme();
                if (isDark) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<UserProfile>(
                valueListenable: ProfileController.profileNotifier,
                builder: (context, userProfile, _) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ProfileAvatar(radius: 30, showShadow: true),
                    title: Text(
                      userProfile.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    subtitle: Text(
                      userProfile.email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  );
                },
              ),
              Gap(40.h),
              _buildSettingItem(
                context,
                title: 'Edit Profile',
                subtitle: 'photo, name, email, password',
                icon: Icons.person_outline,
                onTap: () {
                  MainScreen.navigateToTab(context, 2);
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Previous Test Results',
                subtitle: 'Already haved ** results',
                icon: Icons.history,
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const PreviousScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        final tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: Curves.easeInOutCubic));
                        final offsetAnimation = animation.drive(tween);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Your Activity',
                subtitle: 'View and manage your Courses',
                icon: Icons.bar_chart,
                onTap: () {
                  MainScreen.navigateToTab(context, 0);
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Technical Support',
                subtitle: 'Need help',
                icon: Icons.support_agent,
                onTap: () {},
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Time Management',
                subtitle: 'Daily limits, sleep mode',
                icon: Icons.access_time,
                onTap: () {},
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          widget.isInTabView
              ? null
              : NavBar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  // Navigate to the appropriate screen based on the selected index
                  if (index != 3) {
                    // If not the current settings screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          switch (index) {
                            case 0: // Dashboard
                              return const DashBoardScreen();
                            case 1: // Statistics
                              return const StaticsScreen();
                            case 2: // Profile
                              return const ProfileScreen();
                            default:
                              return const SettingScreen();
                          }
                        },
                      ),
                    );
                  }
                },
              ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color:
            themeProvider.isDarkMode
                ? Colors.grey.shade800.withAlpha(77)
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color:
                        themeProvider.isDarkMode
                            ? const Color(0xFF201B39).withAlpha(179)
                            : const Color(0xFF201B39).withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color:
                        themeProvider.isDarkMode
                            ? const Color(0xFF6A5ACD)
                            : const Color(0xFF1C1259),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color:
                      themeProvider.isDarkMode
                          ? const Color(0xFF6A5ACD)
                          : const Color(0xFF1C1259),
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
