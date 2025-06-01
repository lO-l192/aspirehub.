import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aspirehub3/Models/personality_analysis.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/main_screen.dart';

import 'package:aspirehub3/widgets/buttonNavigationBar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Custom widget for hover effects
class HoverBuilder extends StatefulWidget {
  final Widget Function(BuildContext, bool) builder;

  const HoverBuilder({super.key, required this.builder});

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: widget.builder(context, isHovered),
    );
  }
}

class PreviousScreen extends StatefulWidget {
  final bool isInTabView;

  const PreviousScreen({super.key, this.isInTabView = false});

  @override
  State<PreviousScreen> createState() => _PreviousScreenState();
}

class _PreviousScreenState extends State<PreviousScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<PersonalityAnalysis> _filteredAnalyses = [];
  late AnimationController _animationController;
  final List<Animation<double>> _cardAnimations = [];

  @override
  void initState() {
    super.initState();
    _filteredAnalyses = samplePersonalityAnalyses;

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    for (int i = 0; i < samplePersonalityAnalyses.length; i++) {
      final start = 0.1 + (i * 0.05);
      final end = start + 0.4;
      final curve = Interval(start, end, curve: Curves.easeInOut);

      _cardAnimations.add(
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _animationController, curve: curve)),
      );
    }

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterAnalyses(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredAnalyses = samplePersonalityAnalyses;
      } else {
        _filteredAnalyses =
            samplePersonalityAnalyses
                .where(
                  (analysis) =>
                      analysis.personalityDescription.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      analysis.recommendation.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      analysis.recommendationExplanation.toLowerCase().contains(
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () {
            // Navigate back to the main screen with smooth animation
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const MainScreen(
                          initialTabIndex: 3,
                        ), // Go back to Settings (index 3)
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  // Create a right-to-left slide animation (opposite of the one used to enter)
                  const begin = Offset(-0.05, 0);
                  const end = Offset.zero;
                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.easeInOutCubic));
                  final offsetAnimation = animation.drive(tween);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
              (route) => false,
            );
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.sp,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Personality Analysis',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Mulish',
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: min(16.w, constraints.maxWidth * 0.05),
                    vertical: min(12.h, constraints.maxHeight * 0.02),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          themeProvider.isDarkMode
                              ? const Color(
                                0xFF2C2C2C,
                              ) // Dark mode input background
                              : const Color(
                                0xFFF1F1F1,
                              ), // Light mode input background
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: min(12.w, constraints.maxWidth * 0.03),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterAnalyses,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: min(14.sp, constraints.maxWidth * 0.04),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your search content here ....',
                        hintStyle: TextStyle(
                          color:
                              themeProvider.isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey,
                          fontSize: min(14.sp, constraints.maxWidth * 0.04),
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color:
                              themeProvider.isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey,
                          size: min(20.sp, constraints.maxWidth * 0.05),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: min(12.h, constraints.maxHeight * 0.02),
                        ),
                      ),
                    ),
                  ),
                ),

                // Analysis Cards List
                Expanded(
                  child:
                      _filteredAnalyses.isEmpty
                          ? Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: min(
                                  16.sp,
                                  constraints.maxWidth * 0.04,
                                ),
                                color:
                                    themeProvider.isDarkMode
                                        ? Colors.grey.shade400
                                        : Colors.grey,
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: min(
                                16.w,
                                constraints.maxWidth * 0.05,
                              ),
                              vertical: min(8.h, constraints.maxHeight * 0.01),
                            ),
                            // Add physics for smoother scrolling
                            physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics(),
                            ),
                            // Add caching for better performance
                            cacheExtent: 1000,
                            itemCount: _filteredAnalyses.length,
                            itemBuilder: (context, index) {
                              final analysis = _filteredAnalyses[index];
                              // Add staggered animation for cards
                              final animation =
                                  index < _cardAnimations.length
                                      ? _cardAnimations[index]
                                      : _animationController;

                              return AnimatedBuilder(
                                animation: animation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      20 * (1 - animation.value),
                                    ),
                                    child: Opacity(
                                      opacity: animation.value,
                                      child: _buildAnalysisCard(analysis),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar:
          widget.isInTabView
              ? null
              : NavBar(
                // Use a default selected index (e.g., 3 for Settings since we came from there)
                selectedIndex: 3,
                onItemSelected: (index) {
                  // Navigate to MainScreen with the selected tab index and smooth animation
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (
                            context,
                            animation,
                            secondaryAnimation,
                          ) => MainScreen(
                            initialTabIndex: index,
                          ), // Can't use const here because index is variable
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        // Create a combined animation similar to the one in MainScreen
                        // Fade transition
                        final fadeAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutCubic,
                          ),
                        );

                        // Slide transition
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(-0.05, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutCubic,
                          ),
                        );

                        // Scale transition
                        final scaleAnimation = Tween<double>(
                          begin: 0.98,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutCubic,
                          ),
                        );

                        return FadeTransition(
                          opacity: fadeAnimation,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: ScaleTransition(
                              scale: scaleAnimation,
                              child: child,
                            ),
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                    (route) => false,
                  );
                },
              ),
    );
  }

  // Helper function to get minimum value
  double min(double a, double b) {
    return a < b ? a : b;
  }

  Widget _buildAnalysisCard(PersonalityAnalysis analysis) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return HoverBuilder(
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(isHovered ? 1.03 : 1.0),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color:
                    themeProvider.isDarkMode
                        ? Colors.black.withAlpha(isHovered ? 60 : 40)
                        : Colors.black.withAlpha(isHovered ? 40 : 26),
                blurRadius: isHovered ? 12.r : 8.r,
                offset: Offset(0, isHovered ? 4.h : 2.h),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                // Add haptic feedback for better user experience
                HapticFeedback.lightImpact();
              },
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personality Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Personality:',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Mulish',
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                          ),
                        ),
                        Text(
                          'Date: ${analysis.formattedDate}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                themeProvider.isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey[700],
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color:
                            themeProvider.isDarkMode
                                ? const Color(0xFF6A5ACD).withAlpha(
                                  77,
                                ) // 0.3 opacity
                                : const Color(
                                  0xFFEFEEFA,
                                ), // Light slateblue for light mode
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        analysis.personalityDescription,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),

                    // Recommendation Section
                    SizedBox(height: 16.h),
                    Text(
                      'Recommendation:',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mulish',
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color:
                            themeProvider.isDarkMode
                                ? const Color(0xFF6A5ACD).withAlpha(
                                  77,
                                ) // 0.3 opacity
                                : const Color(
                                  0xFFEFEEFA,
                                ), // Light slateblue for light mode
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        analysis.fullRecommendation,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
