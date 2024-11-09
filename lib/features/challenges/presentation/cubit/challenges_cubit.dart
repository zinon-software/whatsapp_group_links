import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/data/models/section_model.dart';
import 'package:linkati/features/challenges/data/repositories/challenges_repositories.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  final ChallengesRepository repository;
  // final List<SectionModel> sections = [];

  ChallengesCubit({required this.repository}) : super(ChallengesInitialState());

  void createSection(SectionModel section) async {
    emit(ManageSectionLoadingState());

    (await repository.createSection(section)).fold((failure) {
      emit(ManageSectionErrorState(failure));
    }, (response) {
      emit(ManageSectionSuccessState(response));
    });
  }

  void updateSection(SectionModel section) async {
    emit(ManageSectionLoadingState());

    (await repository.updateSection(section)).fold((failure) {
      emit(ManageSectionErrorState(failure));
    }, (response) {
      emit(ManageSectionSuccessState(response));
    });
  }

  void updateQuestion(QuestionModel question) {}

  void createQuestion(QuestionModel question) {}
}
