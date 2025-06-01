import 'dart:convert';
import 'package:aspirehub3/Models/question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizResult {
  final String title;
  final List<int?> selectedAnswers;
  final List<Question> questions;
  final int timestamp;
  final int score;

  QuizResult({
    required this.title,
    required this.selectedAnswers,
    required this.questions,
    required this.timestamp,
    required this.score,
  });

  // Convert to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'selectedAnswers': selectedAnswers,
      'questions':
          questions
              .map(
                (q) => {
                  'question': q.question,
                  'options': q.options,
                  'correctAnswer': q.correctAnswer,
                },
              )
              .toList(),
      'timestamp': timestamp,
      'score': score,
    };
  }

  // Create from a map for deserialization
  factory QuizResult.fromMap(Map<String, dynamic> map) {
    final List<dynamic> serializedQuestions = map['questions'];
    final List<Question> questions =
        serializedQuestions
            .map(
              (q) => Question(
                question: q['question'],
                options: List<String>.from(q['options']),
                correctAnswer: q['correctAnswer'],
              ),
            )
            .toList();

    return QuizResult(
      title: map['title'],
      selectedAnswers: List<int?>.from(map['selectedAnswers']),
      questions: questions,
      timestamp: map['timestamp'],
      score: map['score'] ?? 0,
    );
  }

  // Calculate the score
  static int calculateScore(
    List<int?> selectedAnswers,
    List<Question> questions,
  ) {
    int score = 0;
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (i < questions.length &&
          selectedAnswers[i] == questions[i].correctAnswer) {
        score++;
      }
    }
    return score;
  }

  // Format the date
  String get formattedDate {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get the score as a string
  String get scoreText {
    return '$score/${questions.length}';
  }
}

class QuizResultsManager {
  static const String _quizResultsKey = 'quiz_results_list';

  // Save quiz results to SharedPreferences
  static Future<void> saveQuizResults(
    String title,
    List<int?> selectedAnswers,
    List<Question> questions,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Calculate the score
      final int score = QuizResult.calculateScore(selectedAnswers, questions);

      // Create a new quiz result
      final QuizResult newResult = QuizResult(
        title: title,
        selectedAnswers: selectedAnswers,
        questions: questions,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        score: score,
      );

      // Get existing results
      List<QuizResult> results = await loadAllQuizResults();

      // Add the new result
      results.add(newResult);

      // Save all results
      final List<Map<String, dynamic>> serializedResults =
          results.map((r) => r.toMap()).toList();
      await prefs.setString(_quizResultsKey, jsonEncode(serializedResults));
    } catch (e) {
      print('Error saving quiz results: $e');
    }
  }

  // Load all quiz results from SharedPreferences
  static Future<List<QuizResult>> loadAllQuizResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? resultsJson = prefs.getString(_quizResultsKey);

      if (resultsJson == null || resultsJson.isEmpty) {
        return [];
      }

      final List<dynamic> resultsData = jsonDecode(resultsJson);
      return resultsData.map((data) => QuizResult.fromMap(data)).toList();
    } catch (e) {
      print('Error loading quiz results: $e');
      return [];
    }
  }

  // Check if quiz results exist
  static Future<bool> hasQuizResults() async {
    try {
      final results = await loadAllQuizResults();
      return results.isNotEmpty;
    } catch (e) {
      print('Error checking quiz results: $e');
      return false;
    }
  }

  // Clear all quiz results
  static Future<void> clearAllQuizResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_quizResultsKey);
    } catch (e) {
      print('Error clearing quiz results: $e');
    }
  }

  // Delete a specific quiz result by timestamp
  static Future<void> deleteQuizResult(int timestamp) async {
    try {
      List<QuizResult> results = await loadAllQuizResults();
      results.removeWhere((result) => result.timestamp == timestamp);

      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> serializedResults =
          results.map((r) => r.toMap()).toList();
      await prefs.setString(_quizResultsKey, jsonEncode(serializedResults));
    } catch (e) {
      print('Error deleting quiz result: $e');
    }
  }
}
