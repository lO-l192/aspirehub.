import 'package:aspirehub3/screens/statics_screen.dart';
import 'package:flutter/material.dart';
import 'package:aspirehub3/Models/question.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/widgets/custom_button.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizResultScreen extends StatelessWidget {
  final List<int?> selectedAnswers;
  final List<Question> questions;

  const QuizResultScreen({
    super.key,
    required this.selectedAnswers,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    int score = 0;
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        score++;
      }
    }

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Quiz Results',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Mulish',
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color:
                    themeProvider.isDarkMode
                        ? const Color(0xFF6A5ACD).withAlpha(
                          40,
                        ) // Slateblue with alpha for dark mode
                        : const Color(0xFF1C1259).withAlpha(
                          20,
                        ), // Original color with alpha for light mode
                border: Border.all(
                  color:
                      themeProvider.isDarkMode
                          ? const Color(0xFF6A5ACD).withAlpha(
                            100,
                          ) // Slateblue border for dark mode
                          : const Color(0xFF1C1259).withAlpha(
                            50,
                          ), // Original color border for light mode
                  width: 1.w,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Score',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CircularPercentIndicator(
                    radius: 60.r,
                    lineWidth: 10.0,
                    percent: questions.isEmpty ? 0 : score / questions.length,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                themeProvider.isDarkMode
                                    ? const Color(
                                      0xFF6A5ACD,
                                    ) // Slateblue for dark mode
                                    : const Color(
                                      0xFF1C1259,
                                    ), // Original color for light mode
                            fontFamily: 'Mulish',
                          ),
                        ),
                        Text(
                          '/${questions.length}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).textTheme.titleMedium?.color,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ],
                    ),
                    backgroundColor:
                        themeProvider.isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                    progressColor:
                        themeProvider.isDarkMode
                            ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                            : const Color(
                              0xFF1C1259,
                            ), // Original color for light mode
                    animation: true,
                    animationDuration: 1000,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  SizedBox(height: 15.h),
                  // Score text
                  Text(
                    '${((questions.isEmpty ? 0 : score / questions.length) * 100).toInt()}% Correct',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          themeProvider.isDarkMode
                              ? const Color(
                                0xFF6A5ACD,
                              ) // Slateblue for dark mode
                              : const Color(
                                0xFF1C1259,
                              ), // Original color for light mode
                      fontFamily: 'Mulish',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Column(
              children: List.generate(questions.length, (index) {
                final question = questions[index];
                final selectedAnswer = selectedAnswers[index];
                final isCorrect = selectedAnswer == question.correctAnswer;

                return Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color:
                        isCorrect
                            ? (themeProvider.isDarkMode
                                ? const Color(0xFF1B5E20).withAlpha(
                                  77,
                                ) // Darker green for dark mode
                                : Colors.green.withAlpha(26))
                            : (themeProvider.isDarkMode
                                ? const Color(0xFF8B0000).withAlpha(
                                  77,
                                ) // Darker red for dark mode
                                : Colors.red.withAlpha(26)),
                    border: Border.all(
                      color:
                          isCorrect
                              ? (themeProvider.isDarkMode
                                  ? const Color(0xFF66BB6A).withAlpha(
                                    128,
                                  ) // Green border for dark mode
                                  : Colors.green.withAlpha(77))
                              : (themeProvider.isDarkMode
                                  ? const Color(0xFFEF5350).withAlpha(
                                    128,
                                  ) // Red border for dark mode
                                  : Colors.red.withAlpha(77)),
                      width: 1.w,
                    ),
                    boxShadow:
                        themeProvider.isDarkMode
                            ? [] // No shadow in dark mode
                            : [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 4.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(question.options.length, (i) {
                          final optionText = question.options[i];
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              '${String.fromCharCode(65 + i)}. $optionText',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight:
                                    selectedAnswer == i
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    selectedAnswer == i
                                        ? (isCorrect
                                            ? (themeProvider.isDarkMode
                                                ? const Color(
                                                  0xFF66BB6A,
                                                ) // Light green for dark mode
                                                : Colors.green)
                                            : (themeProvider.isDarkMode
                                                ? const Color(
                                                  0xFFEF5350,
                                                ) // Light red for dark mode
                                                : Colors.red))
                                        : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                              ),
                            ),
                          );
                        }),
                      ),
                      if (!isCorrect) ...[
                        SizedBox(height: 8.h),
                        Text(
                          'Correct Answer: ${String.fromCharCode(65 + question.correctAnswer)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                themeProvider.isDarkMode
                                    ? const Color(
                                      0xFF64B5F6,
                                    ) // Light blue for dark mode
                                    : const Color(
                                      0xFF1976D2,
                                    ), // Darker blue for light mode
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: Center(
                child: CustomButton(
                  width: 200.w,
                  height: 50.h,
                  borderRadius: 12,
                  text: 'View Statistics',
                  color:
                      themeProvider.isDarkMode
                          ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                          : const Color(
                            0xFF1C1259,
                          ), // Original color for light mode
                  buttontext: Colors.white,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StaticsScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
