import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/personality_question.dart';
import '../services/personality_test_service.dart';
import 'thanks.dart';

class StudentQuizScreen extends StatefulWidget {
  const StudentQuizScreen({super.key});

  @override
  State<StudentQuizScreen> createState() => _StudentQuizScreenState();
}

class _StudentQuizScreenState extends State<StudentQuizScreen> {
  final PersonalityTestService _testService = PersonalityTestService();

  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;

  bool _isLoading = true;
  List<PersonalityQuestion> _questions = [];
  List<PersonalityOption?> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _testService.getQuestions();
      setState(() {
        _questions = questions;
        _selectedOptions = List.filled(questions.length, null);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load questions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _questions.isEmpty
                ? _buildErrorView()
                : _buildQuizContent(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              'Failed to load personality test questions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _loadQuestions();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1053),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Try Again",
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final progressPercent = (_currentQuestionIndex + 1) / _questions.length;
    final progressText = '${_currentQuestionIndex + 1}/${_questions.length}';
    final progressValue = (progressPercent * 10).toStringAsFixed(2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // Close button and progress indicator
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _showExitConfirmationDialog();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 16.sp,
                      color: Colors.black87,
                    ),
                    Text(
                      'close',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    progressText,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 50.w), // Balance the layout
            ],
          ),

          SizedBox(height: 24.h),

          // Progress circle
          Center(
            child: CircularPercentIndicator(
              radius: 45.0,
              lineWidth: 8.0,
              percent: progressPercent,
              center: Text(
                progressValue,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1053),
                ),
              ),
              progressColor: const Color(0xFF1A1053),
              backgroundColor: Colors.grey.shade200,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 500,
            ),
          ),

          SizedBox(height: 24.h),

          // Question text
          Text(
            currentQuestion.question,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 16.h),

          // Question image
          if (currentQuestion.imagePath != null)
            Center(
              child: Image.asset(
                currentQuestion.imagePath!,
                height: 150.h,
                fit: BoxFit.contain,
              ),
            ),

          SizedBox(height: 24.h),

          // Answer options
          ...List.generate(
            currentQuestion.options.length,
            (index) => _buildOptionItem(index, currentQuestion.options[index]),
          ),

          SizedBox(height: 50.h),

          SizedBox(
            width: double.infinity,
            height: 43.h,
            child: ElevatedButton(
              onPressed:
                  _selectedOptions[_currentQuestionIndex] != null
                      ? _goToNextQuestion
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1053),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Text(
                _currentQuestionIndex < _questions.length - 1
                    ? "Next"
                    : "Finish",
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildOptionItem(int index, PersonalityOption option) {
    final isSelected = _selectedOptionIndex == index;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOptionIndex = index;
            _selectedOptions[_currentQuestionIndex] = option;
          });
        },
        child: Container(
          height: 47.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEEEBF9) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? const Color(0xFF1A1053) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 10.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 16.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? const Color(0xFF1A1053) : Colors.transparent,
                  border: Border.all(
                    color:
                        isSelected ? Colors.transparent : Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                child:
                    isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 12.sp)
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      _showFinishConfirmationDialog();
    }
  }

  void _showFinishConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            elevation: 10,
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Close dialog
                      },
                      child: const Icon(Icons.close, color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Do you want to finish the test?',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      // No button
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFB22234,
                              ), // Red color
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "NO",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Yes button
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              _completeTest();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF1A1053,
                              ), // Purple color
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _completeTest() {
    // Filter out any null values (shouldn't happen if the button is disabled properly)
    final validOptions =
        _selectedOptions.whereType<PersonalityOption>().toList();

    // Calculate the result
    final result = _testService.calculateResult(validOptions);

    // Navigate to thanks screen first
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ThanksScreen(result: result)),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Exit Quiz?'),
            content: const Text(
              'Your progress will be lost. Are you sure you want to exit?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: const Text('Exit'),
              ),
            ],
          ),
    );
  }
}
