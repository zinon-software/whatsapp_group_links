import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkati/features/qna/data/models/qna_question_model.dart';
import 'package:linkati/features/qna/data/repositories/qna_repositories.dart';

part 'qna_state.dart';

class QnaCubit extends Cubit<QnaState> {
  final QnaRepository repository;
  final List<QnaQuestionModel> qnaQuestions = [];

  QnaCubit({required this.repository}) : super(QnaInitial());

  void fetchQnaQuestionsEvent() async {
    emit(QnaQuestionsLoadingState());
    final result = await repository.fetchQnaQuestions();
    result.fold(
      (error) => emit(QnaQuestionsErrorState(error)),
      (success) {
        qnaQuestions.clear();
        qnaQuestions.addAll(success);
        emit(QnaQuestionsSuccessState(success));
      },
    );
  }

  void updateQuestionEvent(QnaQuestionModel copyWith) async {
    emit(ManageQuestionLoadingState());
    final result = await repository.updateQuestion(copyWith);
    result.fold(
      (error) => emit(ManageQuestionErrorState(error)),
      (success) {
        fetchQnaQuestionsEvent();
        emit(ManageQuestionSuccessState());
      },
    );
  }

  void createQuestionEvent(QnaQuestionModel qnaQuestionModel) async {
    emit(ManageQuestionLoadingState());
    final result = await repository.createQuestion(qnaQuestionModel);
    result.fold(
      (error) => emit(ManageQuestionErrorState(error)),
      (success) {
        fetchQnaQuestionsEvent();
        emit(ManageQuestionSuccessState());
      },
    );
  }
}
