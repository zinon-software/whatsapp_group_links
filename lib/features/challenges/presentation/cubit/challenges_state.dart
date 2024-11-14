part of 'challenges_cubit.dart';

abstract class ChallengesState extends Equatable {
  const ChallengesState();

  @override
  List<Object> get props => [];
}

class ChallengesInitialState extends ChallengesState {}

class ManageTopicLoadingState extends ChallengesState {}

class ManageTopicSuccessState extends ChallengesState {
  final String message;

  const ManageTopicSuccessState(this.message);
}

class ManageTopicErrorState extends ChallengesState {
  final String failure;
  const ManageTopicErrorState(this.failure);
}

class FetchTopicsLoadingState extends ChallengesState {}

class FetchTopicsSuccessState extends ChallengesState {
  final List<TopicModel> topics;
  const FetchTopicsSuccessState(this.topics);
}

class FetchTopicsErrorState extends ChallengesState {
  final String failure;
  const FetchTopicsErrorState(this.failure);
}

class ManageQuestionErrorState extends ChallengesState {
  final String failure;
  const ManageQuestionErrorState(this.failure);
}

class ManageQuestionSuccessState extends ChallengesState {
  final String message;
  const ManageQuestionSuccessState(this.message);
}

class ManageQuestionLoadingState extends ChallengesState {}

class FetchQuestionsLoadingState extends ChallengesState {}

class FetchQuestionsSuccessState extends ChallengesState {
  final List<QuestionModel> questions;
  const FetchQuestionsSuccessState(this.questions);
}

class FetchQuestionsErrorState extends ChallengesState {
  final String failure;
  const FetchQuestionsErrorState(this.failure);
}

class ManageGameLoadingState extends ChallengesState {}

class ManageGameSuccessState extends ChallengesState {
  final GameModel game;
  final bool isJoined;
  const ManageGameSuccessState({required this.game, this.isJoined = false});
}

class ManageGameErrorState extends ChallengesState {
  final String failure;
  const ManageGameErrorState(this.failure);
}


class GoToGameState extends ChallengesState {
  final GameModel game;
  const GoToGameState({required this.game});
}
