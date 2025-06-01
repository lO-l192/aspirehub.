import 'package:aspirehub3/Models/DashBoard/dashcard.dart';
import 'package:aspirehub3/Models/DashBoard/listtile.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/play_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CourseDashBoard extends StatelessWidget {
  final String imagePath;

  const CourseDashBoard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 70.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: const DashListtile(subtitle: 'Your job : Auditor'),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: Hero(
                  tag: imagePath,
                  child: Image.asset(
                    imagePath,
                    height: 300.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Your Courses',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  children: [
                    const ProgressCard(
                      title: 'Certified Public Accountant',
                      subtitle: 'All can be perfect in Certified Public...',
                      progress: 0.2,
                      cardext: 'Description...',
                      targetPage: PlayListScreen(),
                    ),
                    SizedBox(height: 15.h),
                    const ProgressCard(
                      title: 'Professional Graphic Designer',
                      subtitle: 'All can be perfect in Graphic Design...',
                      progress: 0.4,
                      cardext: 'Learn the art of visuals...',
                      targetPage: PlayListScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
