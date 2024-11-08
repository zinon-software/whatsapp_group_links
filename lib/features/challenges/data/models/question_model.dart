class QuestionModel {
  final String id;
  final String section;
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionModel({
    required this.id,
    required this.section,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      section: json['section'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section': section,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
    };
  }
}