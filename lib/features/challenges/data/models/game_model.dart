import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkati/features/users/data/models/user_model.dart';

class GameModel {
  final String id;
  final PlayerModel player1;
  final PlayerModel? player2;
  final String topic;
  final int questionCount;
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
    required this.questionCount,
    required this.currentTurnPlayerId,
    required this.currntQuestionId,
    required this.currentQuestionNumber,
    required this.startedAt,
    this.endedAt,
    required this.duration,
    this.isWithAi = false,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    GameModel game = GameModel(
      id: json['id'],
      player1: PlayerModel.fromJson(json['player1']),
      player2: json['player2'] != null
          ? PlayerModel.fromJson(json['player2'])
          : null,
      topic: json['topic'],
      questionCount: json['question_count'] ?? 10,
      currentTurnPlayerId: json['current_turn_player_id'],
      currntQuestionId: json['currnt_question_id'],
      currentQuestionNumber: json['current_question_number'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt:
          json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      duration: Duration(seconds: json['duration']),
      isWithAi: json['is_with_ai'] ?? false,
    );

    game.player1.copyWith(correctAnswer: json['correct_answer_player1']);
    if(game.player2 != null) {
      game.player2!.copyWith(correctAnswer: json['correct_answer_player2']);
    }

    return game;
  }

  Map<String, dynamic> toJson({String? id}) {
    return {
      'id': id ?? this.id,
      'player1': player1.toJson(),
      'player2': player2?.toJson(),
      'topic': topic,
      'question_count': questionCount,
      'correct_answer_player1': player1.correctAnswer,
      'correct_answer_player2': player2?.correctAnswer,
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
    int? questionCount,
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
      questionCount: questionCount ?? this.questionCount,
      currentTurnPlayerId: currentTurnPlayerId,
      currntQuestionId: currntQuestionId ?? this.currntQuestionId,
      currentQuestionNumber:
          currentQuestionNumber ?? this.currentQuestionNumber,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      isWithAi: isWithAi ?? this.isWithAi,
    );
  }

  PlayerModel get myPlayer =>
      player1.userId == FirebaseAuth.instance.currentUser!.uid
          ? player1
          : (player2 ?? player1);

  PlayerModel get otherPlayer =>
      player1.userId == FirebaseAuth.instance.currentUser!.uid
          ? player2 ?? player1
          : player1;

  bool get isMePlayer1 =>
      player1.userId == FirebaseAuth.instance.currentUser!.uid;
}

class PlayerModel {
  final String userId;
  final int score;
  final String? correctAnswer;
  UserModel? user;

  PlayerModel({
    required this.userId,
    required this.score,
    this.correctAnswer,
    this.user,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      userId: json['user_id'],
      score: json['score'],
      correctAnswer: json['correct_answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'score': score,
      'correct_answer': correctAnswer,
    };
  }

  // copy with
  PlayerModel copyWith({
    String? userId,
    int? score,
    UserModel? user,
    String? correctAnswer,
  }) {
    return PlayerModel(
      userId: userId ?? this.userId,
      correctAnswer: correctAnswer,
      score: score ?? this.score,
      user: user ?? this.user,
    );
  }
}
