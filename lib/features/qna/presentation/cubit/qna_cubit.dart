import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/notification/send_notification.dart';
import 'package:linkati/core/storage/storage_repository.dart';
import 'package:linkati/features/qna/data/models/qna_answer_model.dart';
import 'package:linkati/features/qna/data/models/qna_question_model.dart';
import 'package:linkati/features/qna/data/repositories/qna_repositories.dart';
import 'package:linkati/features/users/data/models/user_model.dart';

part 'qna_state.dart';

class QnaCubit extends Cubit<QnaState> {
  final QnaRepository repository;
  List<QnaQuestionModel> qnaQuestions = [];

  QnaCubit({required this.repository}) : super(QnaInitial());

  void fetchQnaQuestionsEvent() async {
    emit(QnaQuestionsLoadingState());
    final result = await repository.fetchQnaQuestions();
    result.fold(
      (error) => emit(QnaQuestionsErrorState(error)),
      (success) {
        qnaQuestions = success;
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
        emit(ManageQuestionSuccessState());
        fetchQnaQuestionsEvent();
      },
    );
  }

  void createQuestionEvent(QnaQuestionModel qnaQuestionModel) async {
    emit(ManageQuestionLoadingState());
    final result = await repository.createQuestion(qnaQuestionModel);
    result.fold(
      (error) => emit(ManageQuestionErrorState(error)),
      (success) {
        emit(ManageQuestionSuccessState());
        fetchQnaQuestionsEvent();
      },
    );
  }

  void createAnswerEvent(
      QnaAnswerModel newAnswer, String questionAuthorId) async {
    emit(ManageAnswerLoadingState());

    final result = await repository.createAnswer(newAnswer);
    UserModel? poster = instance<StorageRepository>()
        .getData(key: questionAuthorId) as UserModel?;
    result.fold(
      (error) => emit(ManageAnswerErrorState(error)),
      (success) {
        if (poster?.fcmToken != null) {
          sendFCMMessage(
            title: "رد على سؤال",
            body: newAnswer.text,
            token: poster!.fcmToken!,
            data: {"route": "/"},
          );
        }
        emit(ManageAnswerSuccessState());
      },
    );
  }

  void incrementAnswerVotesEvent(String id) async {
    repository.incrementAnswerVotes(id);
  }

  void decrementAnswerVotesEvent(String id) async {
    repository.decrementAnswerVotes(id);
  }

  void deleteQuestionEvent(String id) async {
    emit(ManageQuestionLoadingState());
    final result = await repository.deleteQuestion(id);
    result.fold(
      (error) => emit(ManageQuestionErrorState(error)),
      (success) {
        emit(ManageQuestionSuccessState());
        fetchQnaQuestionsEvent();
      },
    );
  }
}
