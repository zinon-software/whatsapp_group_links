import 'package:cloud_firestore/cloud_firestore.dart';

class QnaAnswerModel {
  final String id; // ID الخاص بالإجابة
  final String questionId; // ID السؤال المرتبط
  final String authorId; // ID الكاتب
  final String text; // نص الإجابة
  final int votes; // عدد التصويتات
  final DateTime createdAt; // وقت الإنشاء

  QnaAnswerModel({
    required this.id,
    required this.questionId,
    required this.authorId,
    required this.text,
    this.votes = 0,
    required this.createdAt,
  });

  // تحويل من Map (Firestore) إلى الكائن
  factory QnaAnswerModel.fromJson(Map<String, dynamic> json) {
    return QnaAnswerModel(
      id: json['id'] ?? '',
      questionId: json['question_id'] ?? '',
      authorId: json['author_id'] ?? '',
      text: json['text'] ?? '',
      votes: json['votes'] ?? 0,
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  // تحويل من الكائن إلى Map (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'author_id': authorId,
      'text': text,
      'votes': votes,
      'created_at': createdAt,
    };
  }

  QnaAnswerModel copyWith({
    String? id,
    String? questionId,
    String? authorId,
    String? text,
    int? votes,
    DateTime? createdAt,
  }) {
    return QnaAnswerModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      votes: votes ?? this.votes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
