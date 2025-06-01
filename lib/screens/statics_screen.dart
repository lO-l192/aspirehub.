import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/main_screen.dart';
import 'package:aspirehub3/staticsscreens/best_score_screen.dart';
import 'package:aspirehub3/staticsscreens/personal_screen.dart';
import 'package:aspirehub3/staticsscreens/test_knowledge_screen.dart';
import 'package:aspirehub3/widgets/buttonNavigationBar_widget.dart';
import 'package:aspirehub3/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StaticsScreen extends StatefulWidget {
  final bool isInTabView;

  const StaticsScreen({super.key, this.isInTabView = false});

  @override
  State<StaticsScreen> createState() => _StaticsScreenState();
}

class _StaticsScreenState extends State<StaticsScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late PageController _pageController;

  final List<String> tabs = [
    'Personal statistics',
    'Test your knowledge',
    'Best score',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFFF3F3F3),
      body: Stack(
        children: [
          Positioned(
            top: 60.h, // Change this value to control vertical positioning
            left:
                MediaQuery.of(context).size.width * 0.5 -
                45.r, // Center horizontally
            child: ProfileAvatar(
              radius: 45,
              showShadow: true,
              showBorder: true,
              borderColor: Theme.of(context).cardTheme.color,
              borderWidth: 3,
            ),
          ),

          // Main content container with rounded top corners
          Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Tab navigation
                  Padding(
                    padding: EdgeInsets.only(
                      top: 40.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(tabs.length, (index) {
                        final isSelected = _selectedIndex == index;
                        return GestureDetector(
                          onTap: () => _onTabSelected(index),
                          child: Column(
                            children: [
                              AnimatedDefaultTextStyle(
                                curve: Curves.easeInOutCubic,
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: 'Mulish',
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      isSelected
                                          ? themeProvider.isDarkMode
                                              ? const Color(0xFF6A5ACD)
                                              : Theme.of(
                                                context,
                                              ).textTheme.titleLarge?.color
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withAlpha(150),
                                ),
                                child: Text(tabs[index]),
                              ),
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: isSelected ? 40.w : 0,
                                height: 3,
                                decoration: BoxDecoration(
                                  color:
                                      themeProvider.isDarkMode
                                          ? const Color(0xFF6A5ACD)
                                          : const Color(0xFF1C1259),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  // Divider
                  Divider(
                    thickness: 1,
                    color:
                        themeProvider.isDarkMode
                            ? Colors.grey[700]
                            : Colors.grey[300],
                    height: 20.h,
                  ),

                  // Content area - This will be scrollable and fill the space
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      children: const [
                        PersonalScreen(),
                        TestKnowledgeScreen(),
                        BestScoreScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          widget.isInTabView
              ? null
              : NavBar(
                selectedIndex: 1,
                onItemSelected: (index) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              MainScreen(initialTabIndex: index),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
    );
  }
}
