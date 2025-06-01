import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TestInfoScreen extends StatelessWidget {
  final String title;
  final String duration;
  final String questionCount;
  final String description;
  final List<String> instructions;

  const TestInfoScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.questionCount,
    required this.description,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final accentColor =
        themeProvider.isDarkMode
            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
            : const Color(0xFF1C1259); // Dark blue for light mode

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Test Information',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontFamily: 'Mulish',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test title and basic info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10.r,
                      offset: Offset(0, 5.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 20.sp,
                          color: accentColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontFamily: 'Mulish',
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Icon(
                          Icons.quiz_outlined,
                          size: 20.sp,
                          color: accentColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          questionCount,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              // Test description
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontFamily: 'Mulish',
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),

              SizedBox(height: 25.h),

              // Test instructions
              Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontFamily: 'Mulish',
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      instructions.map((instruction) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: accentColor,
                                size: 18.sp,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  instruction,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 1.5,
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),

              SizedBox(height: 40.h),

              // Start test button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const QuizScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.05, 0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOutCubic,
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    ).then((result) {
                      if (result != null) {
                        Navigator.pop(context, result);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    'Start Test',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
