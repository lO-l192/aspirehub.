import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/video_screen.dart';
import 'package:aspirehub3/widgets/circularprogress.dart';
import 'package:aspirehub3/widgets/videocard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlaylistscreenState();
}

class _PlaylistscreenState extends State<PlayListScreen> {
  List<Map<String, dynamic>> videoData = [
    {'lec': 1, 'time': 3},
    {'lec': 2, 'time': 3},
    {'lec': 3, 'time': 3},
    {'lec': 4, 'time': 3},
    {'lec': 5, 'time': 3},
    {'lec': 6, 'time': 3},
    {'lec': 7, 'time': 3},
    {'lec': 8, 'time': 3},
    {'lec': 9, 'time': 3},
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(18.w),
            child: SizedBox(
              width: double.infinity,
              height: 155.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.surface.withAlpha(50)
                          : const Color(0xFFE5F2FA),
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h, left: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      'Certified Public \nAccountant ',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_filled_sharp,
                            color: Theme.of(context).iconTheme.color,
                            size: 18.sp,
                          ),
                          Text(
                            ' 3 hours',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const CircularProgress(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 210.h, left: 10.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children:
                    videoData.map((video) {
                      return VideoCard(
                        lec: video['lec'],
                        time: video['time'],
                        index: videoData.indexOf(video) + 1,
                        targetPage: const VideoPlayerScreen(),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
