class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

final List<Question> questions = [
  Question(
    question: 'What does a CPA primarily specialize in?',
    options: [
      'Marketing and Sales Strategies',
      'Accounting and Financial Management',
      'Software Development and IT Support',
      'Human Resources and Recruitment',
    ],
    correctAnswer: 1,
  ),
  Question(
    question: 'What is the capital of France?',
    options: ['Berlin', 'Paris', 'Rome', 'London'],
    correctAnswer: 1,
  ),
  Question(
    question: 'What does HTML stand for?',
    options: [
      'HyperText Markup Language',
      'High-Level Machine Language',
      'Home Tool Markup Language',
      'Hyperlink Text Module Language',
    ],
    correctAnswer: 0,
  ),
  Question(
    question: 'Which planet is known as the Red Planet?',
    options: ['Earth', 'Mars', 'Venus', 'Jupiter'],
    correctAnswer: 1,
  ),
  Question(
    question: 'What is Flutter primarily used for?',
    options: [
      'Web Hosting',
      'Database Management',
      'Cross-platform App Development',
      'Cybersecurity',
    ],
    correctAnswer: 2,
  ),
];
