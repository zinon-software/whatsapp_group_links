import 'package:cloud_firestore/cloud_firestore.dart';

class QnaQuestionModel {
  final String id; // ID الخاص بالسؤال
  final String authorId; // ID الكاتب
  final String text; // نص السؤال
  final String? category; // التصنيف (اختياري)
  final bool isPublic; // هل السؤال عام أم خاص
  final bool isAnswered;
  final bool isActive;
  final DateTime createdAt; // وقت الإنشاء
  final int answersCount; // عدد الإجابات المرتبطة

  QnaQuestionModel({
    required this.id,
    required this.authorId,
    required this.text,
    this.category,
    required this.isPublic,
    required this.isAnswered,
    required this.isActive,
    required this.createdAt,
    this.answersCount = 0,
  });

  // تحويل من Map (Firestore) إلى الكائن
  factory QnaQuestionModel.fromJson(Map<String, dynamic> json) {
    return QnaQuestionModel(
      id: json['id'] ?? '',
      authorId: json['author_id'] ?? '',
      text: json['text'] ?? '',
      category: json['category'],
      isPublic: json['is_public'] ?? true,
      isAnswered: json['is_answered'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: (json['created_at'] as Timestamp).toDate(),
      answersCount: json['answers_count'] ?? 0,
    );
  }

  // تحويل من الكائن إلى Map (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'text': text,
      'category': category,
      'is_public': isPublic,
      'is_answered': isAnswered,
      'is_active': isActive,
      'created_at': createdAt,
      'answers_count': answersCount,
    };
  }

  // copyWith
  QnaQuestionModel copyWith({
    String? id,
    String? authorId,
    String? text,
    String? category,
    bool? isPublic,
    bool? isAnswered,
    bool? isActive,
    DateTime? createdAt,
    int? answersCount,
  }) {
    return QnaQuestionModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      text: text ?? this.text,
      category: category ?? this.category,
      isPublic: isPublic ?? this.isPublic,
      isAnswered: isAnswered ?? this.isAnswered,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      answersCount: answersCount ?? this.answersCount,
    );
  }

  static QnaQuestionModel empty() {
    return QnaQuestionModel(
      id: '',
      authorId: '',
      text: '',
      category: null,
      isPublic: true,
      isAnswered: false,
      isActive: true,
      createdAt: DateTime.now(),
      answersCount: 0,
    );
  }
}
