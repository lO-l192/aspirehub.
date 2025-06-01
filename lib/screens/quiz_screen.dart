import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aspirehub3/Models/question.dart';
import 'package:aspirehub3/Models/quiz_results_manager.dart';
import 'package:aspirehub3/Models/theme_provider.dart';
import 'package:aspirehub3/screens/congratution_screen.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  final List<int?> selectedAnswers = List.filled(questions.length, null);

  void nextQuestion() {
    if (selectedAnswers[currentQuestion] != null &&
        currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    }
  }

  void previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
      });
    }
  }

  Future<void> submitQuiz() async {
    if (selectedAnswers[currentQuestion] != null) {
      // Get the title of the quiz (could be passed as a parameter to the QuizScreen)
      const String quizTitle = "Financial Accounting"; // Default title

      // Save the quiz results for persistence
      await QuizResultsManager.saveQuizResults(
        quizTitle,
        selectedAnswers,
        questions,
      );

      // Navigate to the congratulation screen and wait for result
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CongratutionScreen(
                selectedAnswers: selectedAnswers,
                questions: questions,
              ),
        ),
      ).then((result) {
        // When we get a result back, check if we're still mounted
        if (mounted && result != null && result is Map<String, dynamic>) {
          // Return the result to the previous screen
          Navigator.pop(context, result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final bool hasSelectedAnswer = selectedAnswers[currentQuestion] != null;
    final bool isLastQuestion = currentQuestion == questions.length - 1;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
            size: 20.sp,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                SizedBox(height: 30.h),

                // الخيارات
                ...List.generate(question.options.length, (index) {
                  final isSelected = selectedAnswers[currentQuestion] == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnswers[currentQuestion] = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 4.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16.r,
                            backgroundColor:
                                isSelected
                                    ? const Color(0xFFCACAEA)
                                    : const Color(0xFFD4D4D4),
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const Spacer(),

                // أزرار التنقل
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor:
                          currentQuestion > 0
                              ? (themeProvider.isDarkMode
                                  ? const Color(
                                    0xFF6A5ACD,
                                  ) // Slateblue for dark mode
                                  : const Color(
                                    0xFF1C1259,
                                  )) // Original color for light mode
                              : Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : const Color(0xFFD4D4D4),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
                        color: Colors.white,
                        onPressed:
                            currentQuestion > 0 ? previousQuestion : null,
                      ),
                    ),
                    if (!isLastQuestion)
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor:
                            hasSelectedAnswer
                                ? (themeProvider.isDarkMode
                                    ? const Color(
                                      0xFF6A5ACD,
                                    ) // Slateblue for dark mode
                                    : const Color(
                                      0xFF1C1259,
                                    )) // Original color for light mode
                                : Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.grey.shade700
                                : const Color(0xFFD4D4D4),
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 18.sp),
                          color: Colors.white,
                          onPressed: hasSelectedAnswer ? nextQuestion : null,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // زر Submit
          if (isLastQuestion && hasSelectedAnswer)
            Positioned(
              bottom: 80.h,
              left: MediaQuery.of(context).size.width * 0.5 - 60.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      themeProvider.isDarkMode
                          ? const Color(0xFF6A5ACD) // Slateblue for dark mode
                          : const Color(
                            0xFF1C1259,
                          ), // Original color for light mode
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 14.h,
                  ),
                ),
                onPressed: submitQuiz,
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
