import 'package:flutter/material.dart';
import 'package:aspirehub3/Models/question.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PreviousQuizResultScreen extends StatelessWidget {
  final List<int?> selectedAnswers;
  final List<Question> questions;

  const PreviousQuizResultScreen({
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
          'Previous Test Results',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Mulish',
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color:
                    themeProvider.isDarkMode
                        ? const Color(0xFF6A5ACD).withAlpha(
                          40,
                        ) // Slateblue with alpha for dark mode
                        : const Color(
                          0xFFF3F3F3,
                        ), // Original light gray for light mode
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color:
                      themeProvider.isDarkMode
                          ? const Color(0xFF6A5ACD).withAlpha(
                            100,
                          ) // Slateblue border for dark mode
                          : Colors.grey.withAlpha(
                            50,
                          ), // Light gray border for light mode
                  width: 1.w,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Financial Accounting',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      CircularPercentIndicator(
                        radius: 20.r,
                        lineWidth: 4.0,
                        percent:
                            questions.isEmpty ? 0 : score / questions.length,
                        center: Text(
                          '${((questions.isEmpty ? 0 : score / questions.length) * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                themeProvider.isDarkMode
                                    ? const Color(
                                      0xFF6A5ACD,
                                    ) // Slateblue for dark mode
                                    : const Color(
                                      0xFF1C1259,
                                    ), // Original color for light mode
                          ),
                        ),
                        backgroundColor:
                            themeProvider.isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                        progressColor:
                            themeProvider.isDarkMode
                                ? const Color(
                                  0xFF6A5ACD,
                                ) // Slateblue for dark mode
                                : const Color(
                                  0xFF1C1259,
                                ), // Original color for light mode
                        animation: true,
                        animationDuration: 1000,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Your Score: $score/${questions.length}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          score > questions.length / 2
                              ? (themeProvider.isDarkMode
                                  ? Colors.green[300]
                                  : Colors.green)
                              : (themeProvider.isDarkMode
                                  ? Colors.red[300]
                                  : Colors.red),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          themeProvider.isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Question Results',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Mulish',
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: 16.h),
            Column(
              children: List.generate(questions.length, (index) {
                final question = questions[index];
                final selectedAnswer = selectedAnswers[index];
                final isCorrect = selectedAnswer == question.correctAnswer;

                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color:
                        isCorrect
                            ? (themeProvider.isDarkMode
                                ? const Color(0xFF1B5E20).withAlpha(
                                  77,
                                ) // Darker green for dark mode
                                : const Color(
                                  0xFFE8F5E9,
                                )) // Light green for light mode
                            : (themeProvider.isDarkMode
                                ? const Color(0xFF8B0000).withAlpha(
                                  77,
                                ) // Darker red for dark mode
                                : const Color(
                                  0xFFFFEBEE,
                                )), // Light red for light mode
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
                                color: Colors.black.withAlpha(
                                  10,
                                ), // Very light shadow
                                blurRadius: 4.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isCorrect ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              isCorrect ? 'Correct' : 'Incorrect',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Question ${index + 1}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color:
                                  themeProvider.isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        question.question,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontFamily: 'Mulish',
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(question.options.length, (i) {
                          final optionText = question.options[i];
                          final isSelected = selectedAnswer == i;
                          final isCorrectOption = question.correctAnswer == i;

                          return Container(
                            margin: EdgeInsets.only(bottom: 8.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color:
                                  isSelected
                                      ? (isCorrect
                                          ? (themeProvider.isDarkMode
                                              ? const Color(
                                                0xFF1B5E20,
                                              ).withAlpha(
                                                77,
                                              ) // Darker green for dark mode
                                              : Colors.green.withAlpha(51))
                                          : (themeProvider.isDarkMode
                                              ? const Color(
                                                0xFF8B0000,
                                              ).withAlpha(
                                                77,
                                              ) // Darker red for dark mode
                                              : Colors.red.withAlpha(51)))
                                      : (isCorrectOption
                                          ? (themeProvider.isDarkMode
                                              ? const Color(
                                                0xFF1B5E20,
                                              ).withAlpha(
                                                51,
                                              ) // Darker green for dark mode
                                              : Colors.green.withAlpha(26))
                                          : (themeProvider.isDarkMode
                                              ? Theme.of(context).cardColor
                                              : Colors.white)),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? (isCorrect
                                            ? (themeProvider.isDarkMode
                                                ? const Color(
                                                  0xFF66BB6A,
                                                ) // Green for dark mode
                                                : Colors.green)
                                            : (themeProvider.isDarkMode
                                                ? const Color(
                                                  0xFFEF5350,
                                                ) // Red for dark mode
                                                : Colors.red))
                                        : (isCorrectOption
                                            ? (themeProvider.isDarkMode
                                                ? const Color(
                                                  0xFF66BB6A,
                                                ) // Green for dark mode
                                                : Colors.green)
                                            : (themeProvider.isDarkMode
                                                ? Colors.grey.withAlpha(100)
                                                : Colors.grey.withAlpha(77))),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12.r,
                                  backgroundColor:
                                      isSelected
                                          ? (isCorrect
                                              ? (themeProvider.isDarkMode
                                                  ? const Color(
                                                    0xFF66BB6A,
                                                  ) // Green for dark mode
                                                  : Colors.green)
                                              : (themeProvider.isDarkMode
                                                  ? const Color(
                                                    0xFFEF5350,
                                                  ) // Red for dark mode
                                                  : Colors.red))
                                          : (isCorrectOption
                                              ? (themeProvider.isDarkMode
                                                  ? const Color(
                                                    0xFF66BB6A,
                                                  ) // Green for dark mode
                                                  : Colors.green)
                                              : (themeProvider.isDarkMode
                                                  ? Colors.grey.withAlpha(100)
                                                  : Colors.grey.withAlpha(77))),
                                  child: Text(
                                    String.fromCharCode(65 + i),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight:
                                          isSelected || isCorrectOption
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          isSelected
                                              ? (isCorrect
                                                  ? (themeProvider.isDarkMode
                                                      ? Colors.green[300]
                                                      : Colors.green[800])
                                                  : (themeProvider.isDarkMode
                                                      ? Colors.red[300]
                                                      : Colors.red[800]))
                                              : (isCorrectOption
                                                  ? (themeProvider.isDarkMode
                                                      ? Colors.green[300]
                                                      : Colors.green[800])
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.color),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      if (!isCorrect) ...[
                        SizedBox(height: 8.h),
                        Text(
                          'Correct Answer: ${String.fromCharCode(65 + question.correctAnswer)} - ${question.options[question.correctAnswer]}',
                          style: TextStyle(
                            color: const Color(0xFF6A5ACD), // Slateblue color
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
