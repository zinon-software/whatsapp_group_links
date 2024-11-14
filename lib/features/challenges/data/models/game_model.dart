import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/users/data/models/user_model.dart';

class GameModel {
  final String id;
  final PlayerModel player1;
  final PlayerModel? player2;
  final String topic;
  final List<QuestionModel> questions;
  final String? currentTurnPlayerId;
  final String currntQuestionId;
  final int currentQuestionNumber;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration duration;

  GameModel({
    required this.id,
    required this.player1,
    this.player2,
    required this.topic,
    required this.currentTurnPlayerId,
    required this.currntQuestionId,
    required this.questions,
    required this.currentQuestionNumber,
    required this.startedAt,
    this.endedAt,
    required this.duration,
  });

  int get questionCount => questions.length;

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      player1: PlayerModel.fromJson(json['player1']),
      player2: json['player2'] != null
          ? PlayerModel.fromJson(json['player2'])
          : null,
      topic: json['topic'],
      currentTurnPlayerId: json['current_turn_player_id'],
      currntQuestionId: json['currnt_question_id'],
      questions: [],
      currentQuestionNumber: json['current_question_number'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt:
          json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      duration: Duration(seconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson({String? id}) {
    return {
      'id': id ?? this.id,
      'player1': player1.toJson(),
      'player2': player2?.toJson(),
      'topic': topic,
      'current_turn_player_id': currentTurnPlayerId,
      'currnt_question_id': currntQuestionId,
      'current_question_number': currentQuestionNumber,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration': duration.inSeconds,
    };
  }

  // copy with
  GameModel copyWith({
    String? id,
    PlayerModel? player1,
    PlayerModel? player2,
    String? topic,
    List<QuestionModel>? questions,
    String? currentTurnPlayerId,
    String? currntQuestionId,
    int? currentQuestionNumber,
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? duration,
    bool? isWithAi,
  }) {
    return GameModel(
      id: id ?? this.id,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      topic: topic ?? this.topic,
      currentTurnPlayerId: currentTurnPlayerId ?? this.currentTurnPlayerId,
      currntQuestionId: currntQuestionId ?? this.currntQuestionId,
      questions: questions ?? this.questions,
      currentQuestionNumber:
          currentQuestionNumber ?? this.currentQuestionNumber,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
    );
  }
}

class PlayerModel {
  final String userId;
  final int score;
  UserModel? user;

  PlayerModel({
    required this.userId,
    required this.score,
    this.user,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      userId: json['user_id'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'score': score,
    };
  }

  // copy with
  PlayerModel copyWith({String? userId, int? score, UserModel? user}) {
    return PlayerModel(
      userId: userId ?? this.userId,
      score: score ?? this.score,
      user: user ?? this.user,
    );
  }
}
