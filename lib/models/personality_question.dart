class PersonalityQuestion {
  final int id;
  final String question;
  final List<PersonalityOption> options;
  final String? imagePath;
  final String category; // E.g., "Extraversion vs. Introversion"

  PersonalityQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.imagePath,
    required this.category,
  });

  factory PersonalityQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalityQuestion(
      id: json['id'],
      question: json['question'],
      options: (json['options'] as List)
          .map((option) => PersonalityOption.fromJson(option))
          .toList(),
      imagePath: json['imagePath'],
      category: json['category'],
    );
  }
}

class PersonalityOption {
  final String text;
  final String trait; // E.g., "E" for Extraversion, "I" for Introversion
  final int value; // Value to add to the trait score

  PersonalityOption({
    required this.text,
    required this.trait,
    required this.value,
  });

  factory PersonalityOption.fromJson(Map<String, dynamic> json) {
    return PersonalityOption(
      text: json['text'],
      trait: json['trait'],
      value: json['value'],
    );
  }
}

class PersonalityResult {
  final String personalityType; // E.g., "INTJ"
  final Map<String, int> scores; // E.g., {"E": 2, "I": 5, ...}
  final String description;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> careerSuggestions;

  PersonalityResult({
    required this.personalityType,
    required this.scores,
    required this.description,
    required this.strengths,
    required this.weaknesses,
    required this.careerSuggestions,
  });

  factory PersonalityResult.fromJson(Map<String, dynamic> json) {
    return PersonalityResult(
      personalityType: json['personalityType'],
      scores: Map<String, int>.from(json['scores']),
      description: json['description'],
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
      careerSuggestions: List<String>.from(json['careerSuggestions']),
    );
  }
}
