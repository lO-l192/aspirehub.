import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PersonalScreen extends StatelessWidget {
  final ScrollController? scrollController;

  const PersonalScreen({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      physics: const BouncingScrollPhysics(),
      children: [
        // Personal stats card
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color:
                themeProvider.isDarkMode
                    ? Colors.grey.shade800
                    : const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 8.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Statistics',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish',
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(context, number: '12', label: 'Tests Taken'),
                  _buildStatCard(context, number: '85%', label: 'Avg. Score'),
                  _buildStatCard(context, number: '8', label: 'Completed'),
                ],
              ),
            ],
          ),
        ),

        // Progress section
        Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        SizedBox(height: 16.h),

        // Progress cards
        _buildProgressCard(
          context,
          title: 'Accounting Fundamentals',
          progress: 0.75,
        ),
        SizedBox(height: 16.h),
        _buildProgressCard(
          context,
          title: 'Financial Analysis',
          progress: 0.45,
        ),
        SizedBox(height: 16.h),
        _buildProgressCard(context, title: 'Tax Preparation', progress: 0.60),
        SizedBox(height: 16.h),
        _buildProgressCard(
          context,
          title: 'Auditing Principles',
          progress: 0.30,
        ),

        // Recent activity section
        SizedBox(height: 24.h),
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Mulish',
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        SizedBox(height: 16.h),

        // Activity cards
        _buildActivityCard(
          context,
          title: 'Completed "Accounting Basics" quiz',
          time: '2 days ago',
          score: '85%',
        ),
        SizedBox(height: 12.h),
        _buildActivityCard(
          context,
          title: 'Started "Financial Analysis" course',
          time: '1 week ago',
          score: null,
        ),
        SizedBox(height: 12.h),
        _buildActivityCard(
          context,
          title: 'Completed "Tax Preparation" quiz',
          time: '2 weeks ago',
          score: '92%',
        ),

        // Add extra space at the bottom for better scrolling
        SizedBox(height: 50.h),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String number,
    required String label,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            fontFamily: 'Mulish',
            color:
                themeProvider.isDarkMode
                    ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                    : const Color(0xFF1C1259), // Dark blue for light mode
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Mulish',
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
    BuildContext context, {
    required String title,
    required double progress,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final percentage = (progress * 100).toInt();
    final accentColor =
        themeProvider.isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Dark blue for light mode

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Mulish',
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: 12.h),
          // Percentage indicator above progress bar
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color:
                      accentColor, // Using accent color that changes with theme
                  fontFamily: 'Mulish',
                ),
              ),
            ),
          ),
          // Progress bar
          Stack(
            children: [
              // Progress bar background
              Container(
                width: double.infinity,
                height: 12.h,
                decoration: BoxDecoration(
                  color:
                      themeProvider.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              // Progress bar fill
              Container(
                width: (MediaQuery.of(context).size.width - 64.w) * progress,
                height: 12.h,
                decoration: BoxDecoration(
                  color:
                      accentColor, // Using accent color that changes with theme
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // Handle continue button press
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    themeProvider.isDarkMode ? Colors.white : accentColor,
                foregroundColor:
                    themeProvider.isDarkMode ? accentColor : Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Show More',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String time,
    String? score,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final accentColor =
        themeProvider.isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Dark blue for light mode

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: accentColor.withAlpha(26), // 0.1 * 255 = 25.5 ≈ 26
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                score != null ? Icons.check_circle : Icons.play_circle_fill,
                color: accentColor,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontFamily: 'Mulish',
                  ),
                ),
              ],
            ),
          ),
          if (score != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(26), // 0.1 * 255 = 25.5 ≈ 26
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                score,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
