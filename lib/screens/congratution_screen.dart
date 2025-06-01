import 'package:aspirehub3/Models/question.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/quiz_result_screen.dart';
import 'package:aspirehub3/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CongratutionScreen extends StatelessWidget {
  final List<int?> selectedAnswers;
  final List<Question> questions;

  const CongratutionScreen({
    super.key,
    required this.selectedAnswers,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
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
      body: Padding(
        padding: EdgeInsets.only(top: 60.h, left: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Congratulation',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Great job! You Did It',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    themeProvider.isDarkMode
                        ? Colors.grey.shade800
                        : const Color(0xFFF3F3F3),
                child: Icon(
                  Icons.feed_outlined,
                  color: Theme.of(context).iconTheme.color,
                  size: 20.sp,
                ),
              ),
              title: Text(
                'Your Score',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              subtitle: Text(
                '${selectedAnswers.whereType<int>().where((answer) => answer == questions[selectedAnswers.indexOf(answer)].correctAnswer).length}/${questions.length} correct answers',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
            SizedBox(height: 60.h),
            CustomButton(
              width: 193.w,
              height: 42.h,
              borderRadius: 15,
              color:
                  themeProvider.isDarkMode
                      ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                      : const Color(
                        0xFF1C1259,
                      ), // Original color for light mode
              text: 'Viewing your answer',
              buttontext: Colors.white,
              onTap: () {
                // First navigate to the QuizResultScreen to show the answers
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => QuizResultScreen(
                          selectedAnswers: selectedAnswers,
                          questions: questions,
                        ),
                  ),
                );
              },
            ),
            SizedBox(height: 25.h),
            CustomButton(
              borderRadius: 15,
              width: 193.w,
              height: 42.h,
              color:
                  themeProvider.isDarkMode
                      ? Colors.grey.shade800
                      : const Color(0xFFF3F3F3),
              text: 'Go to Statistics',
              buttontext:
                  Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
              onTap: () {
                // Return the quiz results to the TestKnowledgeScreen
                Navigator.pop(context, {
                  'selectedAnswers': selectedAnswers,
                  'questions': questions,
                  'completed': true,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
