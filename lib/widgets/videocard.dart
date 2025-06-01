import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VideoCard extends StatelessWidget {
  final int lec;
  final int time;
  final int index;
  final Widget targetPage;
  const VideoCard({
    super.key,
    required this.lec,
    required this.time,
    required this.index,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: Container(
        width: double.infinity,
        height: 77.h,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26), // 0.1 opacity
              blurRadius: 5.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          title: Text(
            'Lec $lec',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          subtitle: Row(
            children: [
              SizedBox(width: 4.w),
              Text(
                '$time hours',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color
                      ?.withAlpha(153), // 0.6 * 255 = 153
                ),
              ),
            ],
          ),
          trailing: Padding(
            padding: EdgeInsets.only(bottom: 13.h, left: 10.w),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => targetPage),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardTheme.color,
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              icon: Icon(
                Icons.play_circle,
                color:
                    Provider.of<ThemeProvider>(context).isDarkMode
                        ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                        : const Color(
                          0xFF1C1259,
                        ), // Original color for light mode
                size: 25.sp,
              ),
              label: const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
