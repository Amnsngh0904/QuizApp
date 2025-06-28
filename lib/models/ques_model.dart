/*class Question {
  final String id;
  final String question;
  final List<String> options;
  final String answer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: '', // can be filled later if needed
    question: json['question'],
    options: List<String>.from(json['options']),
    answer: json['answer'],
  );
}*/

class Question {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      explanation: json['explanation'] ?? 'No explanation provided.',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
      'explanation': explanation,
    };
  }
}

