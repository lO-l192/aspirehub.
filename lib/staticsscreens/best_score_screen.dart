import 'package:aspirehub3/Models/DashBoard/ranking_item.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BestScoreScreen extends StatelessWidget {
  final ScrollController? scrollController;

  const BestScoreScreen({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final List<Map<String, dynamic>> rankingData = [
      {
        "name": "Ahmed Mohamed",
        "points": 300,
        "image": "assets/images/profile.png",
      },
      {"name": "Sara Ali", "points": 270, "image": "assets/images/profile.png"},
      {
        "name": "Mohamed Fathy",
        "points": 250,
        "image": "assets/images/profile.png",
      },
      {
        "name": "Youssef Salah",
        "points": 200,
        "image": "assets/images/profile.png",
      },
      {
        "name": "Mai Tarek",
        "points": 190,
        "image": "assets/images/profile.png",
      },
      // Add more items to ensure scrolling is necessary
      {
        "name": "Amira Hassan",
        "points": 185,
        "image": "assets/images/profile.png",
      },
      {
        "name": "Omar Khaled",
        "points": 180,
        "image": "assets/images/profile.png",
      },
    ];

    // Use ListView for scrolling
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Top Section: Rank and Message
          SizedBox(height: 10.h), // Reduced spacing
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
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
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color:
                        themeProvider.isDarkMode
                            ? Colors.grey.shade700
                            : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(64), // 0.25 opacity
                        offset: Offset(4.w, 4.h),
                        blurRadius: 8.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "#1",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish',
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Text(
                    'You are doing better than \n60% of other people.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Mulish',
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 30.h),

          // Best Score Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Best score',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // List of Rankings
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: rankingData.length,
            itemBuilder: (context, index) {
              final data = rankingData[index];
              return RankingItem(
                rank: index + 1,
                name: data["name"],
                points: data["points"],
                imagePath: data["image"],
                onTap: () {
                  // Handle tap on ranking item
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected ${data["name"]}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),

          // Add padding at the bottom for better scrolling
          SizedBox(
            height: 20.h,
          ), // Reduced since we already have padding in ListView
        ],
      ),
    );
  }
}
