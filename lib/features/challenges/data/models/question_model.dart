class QuestionModel {
  final String id;
  final String topic;
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionModel({
    required this.id,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      topic: json['topic'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
    );
  }

  Map<String, dynamic> toJson({String? id}) {
    return {
      'id': id ?? this.id,
      'topic': topic,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
    };
  }

  static QuestionModel isEmpty() {
    return QuestionModel(
      id: '',
      topic: '',
      question: '',
      options: [
        '',
        '',
        '',
        '',
      ],
      correctAnswer: '',
    );
  }
}
