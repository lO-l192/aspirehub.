import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final String imagePath;
  final VoidCallback? onTap;

  const RankingItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.imagePath,
    this.onTap,
  });

  Color? _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final medalColor = _getMedalColor(rank);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Material(
        color:
            themeProvider.isDarkMode
                ? Theme.of(context).cardTheme.color
                : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        elevation: 1,
        shadowColor: Colors.black.withAlpha(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                // ترتيب المركز
                Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          themeProvider.isDarkMode
                              ? Colors.grey.shade600
                              : const Color(0xFFE6E6E6),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "$rank",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mulish',
                        color:
                            themeProvider.isDarkMode
                                ? Colors.grey.shade400
                                : const Color.fromARGB(255, 168, 168, 168),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // صورة البروفايل
                Container(
                  width: 62.w,
                  height: 62.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 4.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),

                // الاسم والنقاط
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      Text(
                        "$points Points",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),

                // أيقونة الكأس
                if (medalColor != null)
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: medalColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 6.r,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
