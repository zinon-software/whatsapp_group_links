class SessionModel {
  final String id;
  final PlayerModel player1;
  final PlayerModel player2;
  final String section;
  final String? currentTurnPlayerId;
  final String currntQuestionId;
  final int questionCount;
  final int currentQuestionNumber;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration duration;

  SessionModel({
    required this.id,
    required this.player1,
    required this.player2,
    required this.section,
    required this.currentTurnPlayerId,
    required this.currntQuestionId,
    required this.questionCount,
    required this.currentQuestionNumber,
    required this.startedAt,
    this.endedAt,
    required this.duration,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      player1: PlayerModel.fromJson(json['player1']),
      player2: PlayerModel.fromJson(json['player2']),
      section: json['section'],
      currentTurnPlayerId: json['current_turn_player_id'],
      currntQuestionId: json['currnt_question_id'],
      questionCount: json['question_count'],
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
      'player2': player2.toJson(),
      'section': section,
      'current_turn_player_id': currentTurnPlayerId,
      'currnt_question_id': currntQuestionId,
      'question_count': questionCount,
      'current_question_number': currentQuestionNumber,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration': duration.inSeconds,
    };
  }

  // copy with
  SessionModel copyWith({
    String? id,
    PlayerModel? player1,
    PlayerModel? player2,
    String? section,
    String? currentTurnPlayerId,
    String? currntQuestionId,
    int? questionCount,
    int? currentQuestionNumber,
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? duration,
  }) {
    return SessionModel(
      id: id ?? this.id,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      section: section ?? this.section,
      currentTurnPlayerId: currentTurnPlayerId ?? this.currentTurnPlayerId,
      currntQuestionId: currntQuestionId ?? this.currntQuestionId,
      questionCount: questionCount ?? this.questionCount,
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

  PlayerModel({required this.userId, required this.score});

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
  PlayerModel copyWith({String? userId, int? score}) {
    return PlayerModel(
      userId: userId ?? this.userId,
      score: score ?? this.score,
    );
  }
}
