import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'challenges_state.dart';

class ChallengesCubit extends Cubit<ChallengesState> {
  ChallengesCubit() : super(ChallengesInitial());
}
