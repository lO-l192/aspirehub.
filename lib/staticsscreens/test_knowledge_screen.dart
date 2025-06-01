import 'package:aspirehub3/Models/quiz_results_manager.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/previous_quiz_result_screen.dart';
import 'package:aspirehub3/screens/test_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TestKnowledgeScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const TestKnowledgeScreen({super.key, this.scrollController});

  @override
  State<TestKnowledgeScreen> createState() => _TestKnowledgeScreenState();
}

class _TestKnowledgeScreenState extends State<TestKnowledgeScreen> {
  List<QuizResult> quizResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedQuizResults();
  }

  // Load saved quiz results from storage
  Future<void> _loadSavedQuizResults() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await QuizResultsManager.loadAllQuizResults();
      setState(() {
        quizResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        quizResults = [];
        isLoading = false;
      });
    }
  }

  // Delete a specific quiz result
  Future<void> _deleteQuizResult(int timestamp) async {
    await QuizResultsManager.deleteQuizResult(timestamp);
    setState(() {
      quizResults.removeWhere((result) => result.timestamp == timestamp);
    });
  }

  // Clear all saved quiz results
  Future<void> _clearAllQuizResults() async {
    await QuizResultsManager.clearAllQuizResults();
    setState(() {
      quizResults = [];
    });
  }

  void _startQuiz({required String title, required String subtitle}) async {
    // Parse the subtitle to extract question count and duration
    final parts = subtitle.split('_');
    final questionCount = parts[0].trim();
    final duration = parts[1].trim();

    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => TestInfoScreen(
              title: title,
              duration: duration,
              questionCount: questionCount,
              description:
                  'This test will assess your knowledge of $title concepts. You will have $duration to complete $questionCount. Each question has only one correct answer. Your score will be calculated based on the number of correct answers.',
              instructions: const [
                'Read each question carefully before selecting your answer.',
                'You can navigate between questions using the arrows at the bottom of the screen.',
                'You must select an answer before proceeding to the next question.',
                'Once you submit the test, you cannot change your answers.',
                'Your results will be displayed immediately after submission.',
              ],
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    );
    if (result != null) _loadSavedQuizResults();
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).cardTheme.color,
            title: Text(
              'Clear All Results',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to clear all your test results?',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _clearAllQuizResults();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildTestCard(
            title: 'Certified Public Accountant',
            subtitle: '15 Question _ 30 min',
            onStart: _startQuiz,
          ),
          SizedBox(height: 25.h),
          _buildTestCard(
            title: 'Accounting Fundamentals',
            subtitle: '15 Question _ 30 min',
            onStart: _startQuiz,
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your previous tests',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Mulish',
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              if (quizResults.isNotEmpty)
                TextButton(
                  onPressed: () => _showClearAllDialog(),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Provider.of<ThemeProvider>(context).isDarkMode
                      ? const Color(0xFF6A5ACD)
                      : const Color(0xFF1C1259),
                ),
              ),
            )
          else if (quizResults.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: Text(
                  "You haven't taken any tests yet",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withAlpha(150),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Mulish',
                  ),
                ),
              ),
            )
          else
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children:
                  quizResults
                      .map((result) => _buildQuizResultCard(result))
                      .toList(),
            ),
          SizedBox(height: 50.h), // Extra space at the bottom
        ],
      ),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String subtitle,
    required Function({required String title, required String subtitle})
    onStart,
  }) {
    return GestureDetector(
      onTap: () => onStart(title: title, subtitle: subtitle),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 54.r,
              offset: Offset(10.w, 24.h),
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
                fontWeight: FontWeight.w800,
                fontFamily: 'Mulish',
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontFamily: 'Mulish',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizResultCard(QuizResult result) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16.w),
            leading: Image.asset(
              'assets/images/testpic.png',
              width: 60.w,
              height: 60.h,
              fit: BoxFit.contain,
            ),
            title: Text(
              result.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'Mulish',
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  'Score: ${result.scoreText}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Date: ${result.formattedDate}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontFamily: 'Mulish',
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).iconTheme.color?.withAlpha(150),
              onPressed: () => _deleteQuizResult(result.timestamp),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PreviousQuizResultScreen(
                          selectedAnswers: result.selectedAnswers,
                          questions: result.questions,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Provider.of<ThemeProvider>(context).isDarkMode
                        ? const Color(0xFF6A5ACD)
                        : const Color(0xFF1C1259),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: Text(
                'View Answers',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
