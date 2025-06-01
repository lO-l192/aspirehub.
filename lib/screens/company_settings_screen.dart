import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/models/controller/profile_controller.dart';
import 'package:aspirehub3/widgets/animated_theme_toggle.dart';
import 'package:aspirehub3/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CompanySettingsScreen extends StatefulWidget {
  const CompanySettingsScreen({super.key});

  @override
  State<CompanySettingsScreen> createState() => _CompanySettingsScreenState();
}

class _CompanySettingsScreenState extends State<CompanySettingsScreen>
    with SingleTickerProviderStateMixin {
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
          'Company Settings',
          style: TextStyle(
            fontFamily: 'Mulish',
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
                        fontFamily: 'Mulish',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    subtitle: Text(
                      userProfile.email,
                      style: TextStyle(
                        fontFamily: 'Mulish',
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
                title: 'Company Profile',
                subtitle: 'Edit company details and information',
                icon: Icons.business,
                onTap: () {
                  // Navigate to company profile editing
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Job Listings',
                subtitle: 'Manage your job postings',
                icon: Icons.work_outline,
                onTap: () {
                  // Navigate to job listings management
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Candidate Preferences',
                subtitle: 'Set your candidate matching preferences',
                icon: Icons.people_outline,
                onTap: () {
                  // Navigate to candidate preferences
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Notifications',
                subtitle: 'Manage your notification settings',
                icon: Icons.notifications_outlined,
                onTap: () {
                  // Navigate to notification settings
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Privacy & Security',
                subtitle: 'Manage your account security',
                icon: Icons.security,
                onTap: () {
                  // Navigate to privacy settings
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Help & Support',
                subtitle: 'Contact our support team',
                icon: Icons.support_agent,
                onTap: () {
                  // Navigate to help & support
                },
              ),
              Gap(16.h),
              _buildSettingItem(
                context,
                title: 'Logout',
                subtitle: 'Sign out from your account',
                icon: Icons.logout,
                onTap: () {
                  // Handle logout
                },
              ),
              Gap(20.h),
            ],
          ),
        ),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color:
                        themeProvider.isDarkMode
                            ? const Color(0xFF6A5ACD).withAlpha(26)
                            : const Color(0xFF1C1259).withAlpha(26),
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
                          fontFamily: 'Mulish',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Mulish',
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
