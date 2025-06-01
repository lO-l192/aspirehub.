import 'package:aspirehub3/Models/DashBoard/dashcard.dart';
import 'package:aspirehub3/Models/DashBoard/dashmodel.dart';
import 'package:aspirehub3/Models/DashBoard/listtile.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/course_dash_board_screen.dart';
import 'package:aspirehub3/screens/play_list_screen.dart';
import 'package:aspirehub3/screens/profile_screen.dart';
import 'package:aspirehub3/screens/setting_screen.dart';
import 'package:aspirehub3/screens/statics_screen.dart';
import 'package:aspirehub3/widgets/buttonNavigationBar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  final bool isInTabView;

  const DashBoardScreen({super.key, this.isInTabView = false});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;

  List<DashModel> allRecommendedJobs = [
    const DashModel(
      imagePath: 'assets/images/pers1.png',
      title: 'Software Engineer',
    ),
    const DashModel(
      imagePath: 'assets/images/pers2.png',
      title: 'UI/UX Designer',
    ),
    const DashModel(
      imagePath: 'assets/images/pers3.png',
      title: 'Data Analyst',
    ),
  ];

  List<DashModel> filteredRecommendedJobs = [];

  List<Map<String, dynamic>> allCourses = [
    {
      'title': 'Certified Public Accountant',
      'subtitle': 'All can be perfect in Certified Public...',
      'progress': 0.2,
      'cardext': 'Description...',
    },
    {
      'title': 'Professional Graphic Designer',
      'subtitle': 'Learn Photoshop, Illustrator, and more...',
      'progress': 0.5,
      'cardext': 'Design-focused learning...',
    },
    {
      'title': 'Full Stack Developer Bootcamp',
      'subtitle': 'Master front-end and back-end development...',
      'progress': 0.7,
      'cardext': 'Coding from scratch...',
    },
  ];

  List<Map<String, dynamic>> filteredCourses = [];

  @override
  void initState() {
    super.initState();
    filteredRecommendedJobs = allRecommendedJobs;
    filteredCourses = allCourses;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContent(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        filteredRecommendedJobs = allRecommendedJobs;
        filteredCourses = allCourses;
      } else {
        filteredRecommendedJobs =
            allRecommendedJobs
                .where(
                  (job) =>
                      job.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

        filteredCourses =
            allCourses
                .where(
                  (course) =>
                      course['title'].toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      course['subtitle'].toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      course['cardext'].toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: DashListtile(subtitle: 'Your personality:ISTP'),
              ),
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterContent,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14.sp,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your search content here ....',
                      hintStyle: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14.sp,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withAlpha(150),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Recommended jobs for you',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              filteredRecommendedJobs.isEmpty
                  ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        'No matching jobs found',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withAlpha(150),
                        ),
                      ),
                    ),
                  )
                  : Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          filteredRecommendedJobs.take(3).map((job) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CourseDashBoard(
                                          imagePath: job.imagePath,
                                        ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Hero(
                                    tag: job.imagePath,
                                    child: Image.asset(
                                      job.imagePath,
                                      height: 80.h,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    job.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      fontFamily: 'Mulish',
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.color,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Your Courses',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mulish',
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              filteredCourses.isEmpty
                  ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        'No matching courses found',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withAlpha(150),
                        ),
                      ),
                    ),
                  )
                  : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children:
                          filteredCourses.map((course) {
                            return Column(
                              children: [
                                ProgressCard(
                                  title: course['title'],
                                  subtitle: course['subtitle'],
                                  progress: course['progress'],
                                  cardext: course['cardext'],
                                  targetPage: const PlayListScreen(),
                                ),
                                SizedBox(height: 15.h),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
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
                  setState(() {
                    _selectedIndex = index;
                  });

                  // Navigate to the appropriate screen based on the selected index
                  if (index != 0) {
                    // If not the current dashboard screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          switch (index) {
                            case 1: // Statistics
                              return const StaticsScreen();
                            case 2: // Profile
                              return const ProfileScreen();
                            case 3: // Settings
                              return const SettingScreen();
                            default:
                              return const DashBoardScreen();
                          }
                        },
                      ),
                    );
                  }
                },
              ),
    );
  }
}
