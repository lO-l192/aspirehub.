import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personality_question.dart';

class PersonalityTestService {
  // In a real app, this would be a real API endpoint
  // For demo purposes, we'll use a mock API
  static const String _baseUrl = 'https://mocki.io/v1/';
  static const String _questionsEndpoint = '16personalities-questions';

  // Fetch questions from API
  Future<List<PersonalityQuestion>> getQuestions() async {
    try {
      // In a real app, we would make an actual API call
      // For demo purposes, we'll return mock data
      return _getMockQuestions();
    } catch (e) {
      throw Exception('Failed to load personality test questions: $e');
    }
  }

  // Calculate personality type based on answers
  PersonalityResult calculateResult(List<PersonalityOption> selectedOptions) {
    // Initialize scores for each trait
    Map<String, int> scores = {
      'E': 0, 'I': 0, // Extraversion vs. Introversion
      'S': 0, 'N': 0, // Sensing vs. Intuition
      'T': 0, 'F': 0, // Thinking vs. Feeling
      'J': 0, 'P': 0, // Judging vs. Perceiving
    };

    // Calculate scores based on selected options
    for (var option in selectedOptions) {
      if (scores.containsKey(option.trait)) {
        scores[option.trait] = scores[option.trait]! + option.value;
      }
    }

    // Determine personality type
    String personalityType = '';
    personalityType += scores['E']! > scores['I']! ? 'E' : 'I';
    personalityType += scores['S']! > scores['N']! ? 'S' : 'N';
    personalityType += scores['T']! > scores['F']! ? 'T' : 'F';
    personalityType += scores['J']! > scores['P']! ? 'J' : 'P';

    // Return result with mock data for description, strengths, etc.
    return _getMockResult(personalityType, scores);
  }

  // Mock data for testing - Full 16 questions for the 16 personalities test
  List<PersonalityQuestion> _getMockQuestions() {
    return [
      // Extraversion (E) vs. Introversion (I) - 4 questions
      PersonalityQuestion(
        id: 1,
        question: 'How do you deal with stress and tension in your daily life?',
        options: [
          PersonalityOption(
            text: 'I exercise or meditate.',
            trait: 'I',
            value: 2,
          ),
          PersonalityOption(
            text: 'I share my feelings with friends.',
            trait: 'E',
            value: 2,
          ),
          PersonalityOption(
            text: 'I face it alone and try to overcome it.',
            trait: 'I',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Extraversion vs. Introversion',
      ),
      PersonalityQuestion(
        id: 2,
        question: 'At a party, you usually:',
        options: [
          PersonalityOption(
            text: 'Interact with many, including strangers',
            trait: 'E',
            value: 2,
          ),
          PersonalityOption(
            text: 'Interact with a few people you know',
            trait: 'I',
            value: 2,
          ),
          PersonalityOption(
            text: 'Avoid talking when possible',
            trait: 'I',
            value: 3,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Extraversion vs. Introversion',
      ),
      PersonalityQuestion(
        id: 3,
        question: 'You prefer:',
        options: [
          PersonalityOption(
            text: 'Many friends with brief interactions',
            trait: 'E',
            value: 2,
          ),
          PersonalityOption(
            text: 'A few close friends with more intimate conversations',
            trait: 'I',
            value: 2,
          ),
          PersonalityOption(
            text: 'Spending time alone with your thoughts',
            trait: 'I',
            value: 3,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Extraversion vs. Introversion',
      ),
      PersonalityQuestion(
        id: 4,
        question: 'After a long day, you prefer to:',
        options: [
          PersonalityOption(
            text: 'Go out with friends to recharge',
            trait: 'E',
            value: 3,
          ),
          PersonalityOption(
            text: 'Spend time alone to recharge',
            trait: 'I',
            value: 3,
          ),
          PersonalityOption(
            text: 'Have a quiet dinner with one or two close friends',
            trait: 'I',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Extraversion vs. Introversion',
      ),

      // Sensing (S) vs. Intuition (N) - 4 questions
      PersonalityQuestion(
        id: 5,
        question: 'When learning something new, you prefer:',
        options: [
          PersonalityOption(
            text: 'Concrete, practical examples',
            trait: 'S',
            value: 2,
          ),
          PersonalityOption(
            text: 'Abstract concepts and theories',
            trait: 'N',
            value: 2,
          ),
          PersonalityOption(
            text: 'A mix of both, but leaning towards practical applications',
            trait: 'S',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Sensing vs. Intuition',
      ),
      PersonalityQuestion(
        id: 6,
        question: 'You tend to focus more on:',
        options: [
          PersonalityOption(
            text: 'What is happening now, current reality',
            trait: 'S',
            value: 3,
          ),
          PersonalityOption(
            text: 'What could happen in the future, possibilities',
            trait: 'N',
            value: 3,
          ),
          PersonalityOption(
            text: 'Both, but I am more grounded in the present',
            trait: 'S',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Sensing vs. Intuition',
      ),
      PersonalityQuestion(
        id: 7,
        question: 'When solving problems, you prefer to:',
        options: [
          PersonalityOption(
            text: 'Use proven methods and established procedures',
            trait: 'S',
            value: 2,
          ),
          PersonalityOption(
            text: 'Come up with new, innovative approaches',
            trait: 'N',
            value: 2,
          ),
          PersonalityOption(
            text: 'Improve existing methods with small innovations',
            trait: 'S',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Sensing vs. Intuition',
      ),
      PersonalityQuestion(
        id: 8,
        question: 'You are more interested in:',
        options: [
          PersonalityOption(
            text: 'Facts, details, and concrete information',
            trait: 'S',
            value: 3,
          ),
          PersonalityOption(
            text: 'Patterns, connections, and abstract ideas',
            trait: 'N',
            value: 3,
          ),
          PersonalityOption(
            text: 'A balance of both, but I prefer concrete examples',
            trait: 'S',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Sensing vs. Intuition',
      ),

      // Thinking (T) vs. Feeling (F) - 4 questions
      PersonalityQuestion(
        id: 9,
        question: 'When making decisions, you usually:',
        options: [
          PersonalityOption(
            text: 'Consider feelings and circumstances',
            trait: 'F',
            value: 2,
          ),
          PersonalityOption(
            text: 'Rely on logic and facts',
            trait: 'T',
            value: 2,
          ),
          PersonalityOption(text: 'Trust your instincts', trait: 'F', value: 1),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Thinking vs. Feeling',
      ),
      PersonalityQuestion(
        id: 10,
        question: 'In conflicts, you tend to:',
        options: [
          PersonalityOption(
            text: 'Focus on finding a logical solution',
            trait: 'T',
            value: 3,
          ),
          PersonalityOption(
            text: 'Consider how everyone feels and seek harmony',
            trait: 'F',
            value: 3,
          ),
          PersonalityOption(
            text: 'Try to be fair while considering emotions',
            trait: 'F',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Thinking vs. Feeling',
      ),
      PersonalityQuestion(
        id: 11,
        question: 'You value more:',
        options: [
          PersonalityOption(
            text: 'Truth, even if it hurts feelings',
            trait: 'T',
            value: 2,
          ),
          PersonalityOption(
            text: 'Harmony, even if it means bending the truth',
            trait: 'F',
            value: 2,
          ),
          PersonalityOption(
            text: 'Finding a balance between truth and harmony',
            trait: 'F',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Thinking vs. Feeling',
      ),
      PersonalityQuestion(
        id: 12,
        question: 'When giving feedback, you tend to be:',
        options: [
          PersonalityOption(
            text: 'Direct and straightforward',
            trait: 'T',
            value: 3,
          ),
          PersonalityOption(
            text: 'Gentle and considerate',
            trait: 'F',
            value: 3,
          ),
          PersonalityOption(text: 'Honest but tactful', trait: 'T', value: 1),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Thinking vs. Feeling',
      ),

      // Judging (J) vs. Perceiving (P) - 4 questions
      PersonalityQuestion(
        id: 13,
        question: 'You prefer:',
        options: [
          PersonalityOption(
            text: 'Having a detailed plan and sticking to it',
            trait: 'J',
            value: 3,
          ),
          PersonalityOption(
            text: 'Going with the flow and adapting as needed',
            trait: 'P',
            value: 3,
          ),
          PersonalityOption(
            text: 'Having a general plan but being flexible',
            trait: 'J',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Judging vs. Perceiving',
      ),
      PersonalityQuestion(
        id: 14,
        question: 'Your workspace is usually:',
        options: [
          PersonalityOption(
            text: 'Neat, organized, and structured',
            trait: 'J',
            value: 2,
          ),
          PersonalityOption(
            text: 'Creative chaos with items where I can find them',
            trait: 'P',
            value: 2,
          ),
          PersonalityOption(
            text: 'Somewhat organized but with some clutter',
            trait: 'P',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Judging vs. Perceiving',
      ),
      PersonalityQuestion(
        id: 15,
        question: 'When it comes to deadlines, you:',
        options: [
          PersonalityOption(
            text: 'Complete tasks well ahead of time',
            trait: 'J',
            value: 3,
          ),
          PersonalityOption(
            text: 'Work best under pressure, often finishing just in time',
            trait: 'P',
            value: 3,
          ),
          PersonalityOption(
            text: 'Try to plan ahead but sometimes finish last minute',
            trait: 'P',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Judging vs. Perceiving',
      ),
      PersonalityQuestion(
        id: 16,
        question: 'You prefer environments that are:',
        options: [
          PersonalityOption(
            text: 'Structured with clear expectations',
            trait: 'J',
            value: 2,
          ),
          PersonalityOption(
            text: 'Open-ended with room for spontaneity',
            trait: 'P',
            value: 2,
          ),
          PersonalityOption(
            text: 'Balanced between structure and flexibility',
            trait: 'J',
            value: 1,
          ),
        ],
        imagePath: 'assets/images/app_images/test_image.png',
        category: 'Judging vs. Perceiving',
      ),
    ];
  }

  // Mock result data
  PersonalityResult _getMockResult(
    String personalityType,
    Map<String, int> scores,
  ) {
    // Sample data for INTJ
    if (personalityType == 'INTJ') {
      return PersonalityResult(
        personalityType: 'INTJ',
        scores: scores,
        description:
            'INTJs are analytical problem-solvers, eager to improve systems and processes with their innovative ideas. They have a talent for seeing possibilities for improvement, whether at work, at home, or in themselves.',
        strengths: [
          'Quick, imaginative, and strategic mind',
          'High self-confidence',
          'Independent and decisive',
          'Hard-working and determined',
          'Open-minded',
          'Jack-of-all-trades',
        ],
        weaknesses: [
          'Very private and withdrawn',
          'Perfectionist',
          'Always needs to be right',
          'Judgmental',
          'Overly analytical',
        ],
        careerSuggestions: [
          'Scientists',
          'Engineers',
          'Professors',
          'Teachers',
          'Doctors',
          'Dentists',
          'Programmers',
          'Systems Analysts',
        ],
      );
    }

    // Default mock data for other types
    return PersonalityResult(
      personalityType: personalityType,
      scores: scores,
      description:
          'You are a $personalityType personality type. This is a unique combination of traits that shapes how you think, relate to others, and approach life.',
      strengths: [
        'Analytical thinking',
        'Problem-solving',
        'Creative',
        'Independent',
      ],
      weaknesses: [
        'Can be reserved',
        'Sometimes overthinks',
        'May appear aloof',
      ],
      careerSuggestions: [
        'Business Analyst',
        'Software Developer',
        'Research Scientist',
        'Engineer',
        'Entrepreneur',
      ],
    );
  }
}
