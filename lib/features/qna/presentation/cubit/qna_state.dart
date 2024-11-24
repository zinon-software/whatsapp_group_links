part of 'qna_cubit.dart';

abstract class QnaState extends Equatable {
  const QnaState();

  @override
  List<Object> get props => [];
}

class QnaInitial extends QnaState {}

class ManageQuestionLoadingState extends QnaState {}

class ManageQuestionErrorState extends QnaState {
  final String message;

  const ManageQuestionErrorState(this.message);
}

class ManageQuestionSuccessState extends QnaState {}

class QnaQuestionsLoadingState extends QnaState {}

class QnaQuestionsSuccessState extends QnaState {
  final List<QnaQuestionModel> questions;

  const QnaQuestionsSuccessState(this.questions);
}

class QnaQuestionsErrorState extends QnaState {
  final String message;

  const QnaQuestionsErrorState(this.message);
}