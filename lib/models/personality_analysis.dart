class PersonalityAnalysis {
  final String personalityDescription;
  final DateTime date;
  final String recommendation;
  final String recommendationExplanation;

  PersonalityAnalysis({
    required this.personalityDescription,
    required this.date,
    required this.recommendation,
    required this.recommendationExplanation,
  });

  // Format the date as dd / mm / yyyy
  String get formattedDate {
    return '${date.day} / ${date.month} / ${date.year}';
  }

  // Combine recommendation and explanation
  String get fullRecommendation {
    return '$recommendation: $recommendationExplanation';
  }
}

// Sample data for personality analysis cards
List<PersonalityAnalysis> samplePersonalityAnalyses = [
  PersonalityAnalysis(
    personalityDescription: 'Diplomatic listener and careful planner: Patient, logical, and perceptive.',
    date: DateTime(2024, 10, 6),
    recommendation: 'Web Developer',
    recommendationExplanation: 'we nominated the field for you based on your personality analysis.',
  ),
  PersonalityAnalysis(
    personalityDescription: 'Openness and social responsibility which means they are usually curious, imaginative, and value variety.',
    date: DateTime(2024, 10, 8),
    recommendation: 'UI/UX Designer',
    recommendationExplanation: 'we nominated the field for you based on your personality analysis.',
  ),
  PersonalityAnalysis(
    personalityDescription: 'Analytical thinker with strong problem-solving skills: Detail-oriented, methodical, and persistent.',
    date: DateTime(2024, 9, 28),
    recommendation: 'Data Scientist',
    recommendationExplanation: 'your analytical mindset and attention to detail make you well-suited for this field.',
  ),
  PersonalityAnalysis(
    personalityDescription: 'Creative and empathetic communicator: Expressive, intuitive, and people-oriented.',
    date: DateTime(2024, 9, 15),
    recommendation: 'Content Creator',
    recommendationExplanation: 'your ability to connect with others and express ideas creatively aligns with this career path.',
  ),
];
