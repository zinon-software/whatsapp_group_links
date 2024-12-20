import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkati/core/routes/app_routes.dart';
import 'package:linkati/features/challenges/data/models/game_model.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/data/models/topic_model.dart';
import 'package:linkati/features/challenges/data/repositories/challenges_repositories.dart';

import '../../../../core/notification/send_notification.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final ChallengesRepository repository;
  List<TopicModel> topics = [];

  ChallengesCubit({required this.repository}) : super(ChallengesInitialState());

  void createTopicEvent(TopicModel topic) async {
    emit(ManageTopicLoadingState());

    (await repository.createTopic(topic)).fold((failure) {
      emit(ManageTopicErrorState(failure));
    }, (response) {
      emit(ManageTopicSuccessState(response));
    });
  }

  void updateTopicEvent(TopicModel topic) async {
    emit(ManageTopicLoadingState());

    (await repository.updateTopic(topic)).fold((failure) {
      emit(ManageTopicErrorState(failure));
    }, (response) {
      emit(ManageTopicSuccessState(response));
    });
  }

  void updateQuestionEvent(QuestionModel question) async {
    emit(ManageQuestionLoadingState());

    (await repository.updateQuestion(question)).fold(
      (failure) {
        emit(ManageQuestionErrorState(failure));
      },
      (response) {
        emit(ManageQuestionSuccessState(response));
      },
    );
  }

  void createQuestionEvent(QuestionModel question) async {
    emit(ManageQuestionLoadingState());

    (await repository.createQuestion(question)).fold(
      (failure) {
        emit(ManageQuestionErrorState(failure));
      },
      (response) {
        emit(ManageQuestionSuccessState(response));
      },
    );
  }

  void fetchQuestionsEvent(String topic) async {
    emit(FetchQuestionsLoadingState());

    (await repository.fetchQuestions(topic)).fold(
      (failure) {
        emit(FetchQuestionsErrorState(failure));
      },
      (response) {
        emit(FetchQuestionsSuccessState(response));
      },
    );
  }

  FutureOr<void> fetchTopicsEvent() async {
    emit(FetchTopicsLoadingState());

    (await repository.fetchTopics()).fold(
      (failure) {
        emit(FetchTopicsErrorState(failure));
      },
      (response) {
        topics = response;
        emit(FetchTopicsSuccessState(response));
      },
    );
  }

  Future<void> createGameEvent(
      {required GameModel game}) async {

    emit(ManageGameLoadingState());

    (await repository.createGame(game)).fold(
      (failure) {
        emit(ManageGameErrorState(failure));
      },
      (response) {
        emit(ManageGameSuccessState(game: response));
        sendFCMMessageToAllUsers(
          topic: "allUsers",
          title: 'المتسابق ${response.player1.user?.name} يدعوك الان لمنافسته',
          body:
              'تم انشاء لعبة جديدة في قسم ${topics.firstWhere((element) => element.id == game.topic).title}',
          data: {
            'topic': jsonEncode(topics.firstWhere((element) => element.id == game.topic).toJson()),
            'route': AppRoutes.gamesRoute,
          },
        );
      },
    );
  }

  Future<void> joinGameEvent(GameModel game) async {
    emit(ManageGameLoadingState());

    (await repository.joinGameEvent(game)).fold(
      (failure) {
        emit(ManageGameErrorState(failure));
      },
      (response) {
        emit(ManageGameSuccessState(game: response, isJoined: true));
      },
    );
  }

  Future<void> startGameWithAiEvent(GameModel game) async {
    game = game.copyWith(
      isWithAi: true,
      player2: PlayerModel(
        userId: 'none',
        score: 0,
      ),
      startedAt: DateTime.now(),
    );
    emit(GoToGameState(game: game));

    (await repository.startGameWithAi(game)).fold(
      (failure) {},
      (response) {},
    );
  }

  Future<void> endGameEvent(GameModel game) async {
    repository.endGame(game.copyWith(endedAt: DateTime.now()));

    await repository.deleteGame(game.id);
  }

  void updateGameEvent(GameModel game) async {
    repository.updateGame(game);
  }

  void goToGameEvent(GameModel copyWith) {
    emit(GoToGameState(game: copyWith));
  }
}
