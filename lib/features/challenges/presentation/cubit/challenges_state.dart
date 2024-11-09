part of 'challenges_cubit.dart';

abstract class ChallengesState extends Equatable {
  const ChallengesState();

  @override
  List<Object> get props => [];
}

class ChallengesInitialState extends ChallengesState {}

class ChallengesLoadingState extends ChallengesState {}

class ChallengesLoadedState extends ChallengesState {
  final List<SectionModel> sections;
  const ChallengesLoadedState(this.sections);
}

class ChallengesErrorState extends ChallengesState {}

class ManageSectionLoadingState extends ChallengesState {}

class ManageSectionSuccessState extends ChallengesState {
  final String message;

  const ManageSectionSuccessState(this.message);
}

class ManageSectionErrorState extends ChallengesState {
  final String failure;
  const ManageSectionErrorState(this.failure);
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
