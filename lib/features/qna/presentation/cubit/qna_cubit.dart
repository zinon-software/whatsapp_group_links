import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/core/notification/send_notification.dart';
import 'package:linkati/core/storage/storage_repository.dart';
import 'package:linkati/features/qna/data/models/qna_answer_model.dart';
import 'package:linkati/features/qna/data/models/qna_question_model.dart';
import 'package:linkati/features/qna/data/repositories/qna_repositories.dart';
import 'package:linkati/features/users/data/models/user_model.dart';

import '../../../../core/notification/notification_manager.dart';
import '../../../../core/routes/app_routes.dart';

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
        qnaQuestions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        emit(QnaQuestionsSuccessState(qnaQuestions));
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

  void createQuestionEvent(QnaQuestionModel question) async {
    emit(ManageQuestionLoadingState());
    final result = await repository.createQuestion(question);
    result.fold(
      (error) => emit(ManageQuestionErrorState(error)),
      (success) {
        emit(ManageQuestionSuccessState());
        fetchQnaQuestionsEvent();
        sendFCMMessageToAllUsers(
          title: "موظوع جديد",
          body: question.text,
          data: {
            'question_id': success.id,
            'route': AppRoutes.qnaDetailsRoute,
          },
        );
      },
    );
  }

  void createAnswerEvent(QnaAnswerModel newAnswer) async {
    final result = await repository.createAnswer(newAnswer);
    UserModel? poster = instance<StorageRepository>()
        .getData(key: newAnswer.authorId) as UserModel?;
    result.fold(
      (error) => emit(ManageAnswerErrorState(error)),
      (success) {
        NotificationManager.subscribeToTopic(newAnswer.questionId);
        sendFCMMessageToAllUsers(
          topic: newAnswer.questionId,
          title: 'رد جديد من ${poster?.name ?? ""}',
          body: newAnswer.text,
          data: {
            'question_id': newAnswer.questionId,
            'route': AppRoutes.qnaDetailsRoute,
          },
        );
        emit(ManageAnswerSuccessState());
      },
    );
  }

  void incrementAnswerVotesEvent(QnaAnswerModel newAnswer) async {
    repository.incrementAnswerVotes(newAnswer.id);

    UserModel? poster = instance<StorageRepository>()
        .getData(key: newAnswer.authorId) as UserModel?;
    sendFCMMessage(
      token: poster?.fcmToken ?? "",
      title: 'اعجب ${poster?.name ?? ""} بردك',
      body: newAnswer.text,
      data: {
        'question_id': newAnswer.questionId,
        'route': AppRoutes.qnaDetailsRoute,
      },
    );
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

  void deleteAnswerEvent(String id) {
    repository.deleteAnswer(id);
  }

  void fetchQnaQuestionEvent(String questionId) async {
    emit(QnaQuestionLoadingState());
    final result = await repository.fetchQnaQuestion(questionId);
    result.fold(
      (error) => emit(QnaQuestionErrorState(error)),
      (success) {
        emit(QnaQuestionSuccessState(success));
      },
    );
  }
}
