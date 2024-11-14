import 'package:linkati/features/users/data/models/user_model.dart';

class GameModel {
  final String id;
  final PlayerModel player1;
  final PlayerModel? player2;
  final String topic;
  final String? correctAnswerPlayer1;
  final String? correctAnswerPlayer2;
  final String? currentTurnPlayerId;
  final String currntQuestionId;
  final int currentQuestionNumber;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration duration;
  final bool isWithAi;

  GameModel({
    required this.id,
    required this.player1,
    this.player2,
    required this.topic,
    required this.currentTurnPlayerId,
    required this.currntQuestionId,
    this.correctAnswerPlayer1,
    this.correctAnswerPlayer2,
    required this.currentQuestionNumber,
    required this.startedAt,
    this.endedAt,
    required this.duration,
    this.isWithAi = false,
  });


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
      correctAnswerPlayer1: json['correct_answer_player1'],
      correctAnswerPlayer2: json['correct_answer_player2'],
      currentQuestionNumber: json['current_question_number'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt:
          json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      duration: Duration(seconds: json['duration']),
      isWithAi: json['is_with_ai'] ?? false,

    );
  }

  Map<String, dynamic> toJson({String? id}) {
    return {
      'id': id ?? this.id,
      'player1': player1.toJson(),
      'player2': player2?.toJson(),
      'topic': topic,
      'correct_answer_player1': correctAnswerPlayer1,
      'correct_answer_player2': correctAnswerPlayer2,
      'current_turn_player_id': currentTurnPlayerId,
      'currnt_question_id': currntQuestionId,
      'current_question_number': currentQuestionNumber,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration': duration.inSeconds,
      'is_with_ai': isWithAi,
    };
  }

  // copy with
  GameModel copyWith({
    String? id,
    PlayerModel? player1,
    PlayerModel? player2,
    String? topic,
    String? correctAnswerPlayer1,
    String? correctAnswerPlayer2,
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
      correctAnswerPlayer1: correctAnswerPlayer1 ?? this.correctAnswerPlayer1,
      correctAnswerPlayer2: correctAnswerPlayer2 ?? this.correctAnswerPlayer2,
      currentQuestionNumber:
          currentQuestionNumber ?? this.currentQuestionNumber,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      isWithAi: isWithAi ?? this.isWithAi,
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
