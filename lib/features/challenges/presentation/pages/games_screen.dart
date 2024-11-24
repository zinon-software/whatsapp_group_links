import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:linkati/core/ads/ads_manager.dart';
import 'package:linkati/core/widgets/alert_widget.dart';
import 'package:linkati/core/widgets/custom_button_widget.dart';
import 'package:linkati/features/challenges/data/models/question_model.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';

import '../../../../config/app_injector.dart';
import '../../../../core/api/app_collections.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/game_model.dart';
import '../../data/models/topic_model.dart';
import '../widgets/game_card_widget.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key, required this.topic});
  final TopicModel topic;

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late final UsersCubit _usersCubit;
  late final ChallengesCubit _challengesCubit;
  late final AdsManager _adsManager;

  List<QuestionModel> questions = [];

  @override
  void initState() {
    super.initState();
    _adsManager = AdsManager();
    _usersCubit = context.read<UsersCubit>();
    _challengesCubit = context.read<ChallengesCubit>();

    _challengesCubit.fetchQuestionsEvent(widget.topic.id);
    _adsManager.loadBannerAd(adSize: AdSize.largeBanner);
  }

  @override
  void dispose() {
    _adsManager.disposeBannerAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.title),
      ),
      body: Column(
        children: [
          _adsManager.getBannerAdWidget(padding: const EdgeInsets.all(0.0)),
          Expanded(
            child: BlocListener<ChallengesCubit, ChallengesState>(
              bloc: _challengesCubit,
              listenWhen: (previous, current) =>
                  current is FetchQuestionsSuccessState ||
                  current is FetchQuestionsErrorState ||
                  current is FetchQuestionsLoadingState ||
                  current is ManageGameLoadingState ||
                  current is ManageGameErrorState ||
                  current is ManageGameSuccessState,
              listener: _onListener,
              child: StreamBuilder(
                stream: instance<AppCollections>()
                    .games
                    .where('topic', isEqualTo: widget.topic.id)
                    .where('ended_at', isNull: true)
                    .orderBy('started_at', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('خطأ: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لا توجد بيانات',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 40),
                          CustomButtonWidget(
                            label: 'انشاء تحدي جديدة',
                            onPressed: _createGame,
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final List<GameModel> games = snapshot.data!.docs
                        .map((doc) => GameModel.fromJson(
                            doc.data() as Map<String, dynamic>))
                        .toList();

                    // remove the game after 24 hours
                    for (GameModel game in games) {
                      if (game.startedAt.isBefore(
                          DateTime.now().subtract(const Duration(hours: 24)))) {
                        _challengesCubit.endGameEvent(game);
                      }
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        GameModel game = games[index];
                        return GameCardWidget(
                          game: game,
                          questions: questions,
                          usersCubit: _usersCubit,
                          challengesCubit: _challengesCubit,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('لا توجد بيانات'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _usersCubit.currentUser == null
          ? null
          : FloatingActionButton(
              onPressed: _createGame,
              child: const Icon(Icons.add),
            ),
    );
  }

  void _createGame() async {
    // تحديد العدد المتاح من الأسئلة
    int maxQuestions = questions.length;

    // تقسيم العدد المتاح إلى مجموعة من الخيارات
    List<int> options = [];
    for (int i = 1; i <= maxQuestions ~/ 10; i++) {
      options.add(i * 10);
    }
    if (!options.contains(maxQuestions)) {
      options.add(maxQuestions);
    }

    // عرض حوار لاختيار عدد الأسئلة
    int? selectedQuestionsCount;

    await AppAlert.showAlertWidget(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'حدد عدد اسئلة التحدي',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            children: options
                .map(
                  (option) => InkWell(
                    onTap: () {
                      selectedQuestionsCount = option;
                      AppAlert.dismissDialog(context);
                    },
                    child: Chip(
                      label: Text('$option سؤال'),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );

    if (selectedQuestionsCount != null && selectedQuestionsCount! > 0) {
      Random random = Random();

      // إذا تم اختيار عدد من الأسئلة بشكل صحيح
      _challengesCubit.createGameEvent(
        GameModel(
          id: '',
          player1: PlayerModel(
            userId: _usersCubit.currentUser!.id,
            user: _usersCubit.currentUser!,
            score: 0,
          ),
          topic: widget.topic.id,
          currentTurnPlayerId: null,
          currntQuestionId: questions[random.nextInt(questions.length)].id,
          currentQuestionNumber: 0,
          startedAt: DateTime.now(),
          duration: const Duration(minutes: 30),
          questionCount: selectedQuestionsCount!,
        ),
      );
    }
  }

  void _onListener(context, state) {
    if (state is ManageGameLoadingState) {
      AppAlert.loading(context);
    }
    if (state is ManageGameErrorState) {
      AppAlert.showAlert(context, subTitle: state.failure);
    }
    if (state is ManageGameSuccessState) {
      AppAlert.dismissDialog(context);
      if (state.isJoined) {
        Navigator.of(context).pushNamed(
          AppRoutes.gameRoute,
          arguments: {'game': state.game, "questions": questions},
        );
      } else {
        Navigator.of(context).pushNamed(
          AppRoutes.waitingForPlayerRoute,
          arguments: {'game': state.game, "questions": questions},
        );
      }
    }
    if (state is FetchQuestionsSuccessState) {
      AppAlert.dismissDialog(context);
      questions = state.questions;
    }
    if (state is FetchQuestionsErrorState) {
      AppAlert.showAlert(context, subTitle: state.failure);
    }
    if (state is FetchQuestionsLoadingState) {
      AppAlert.loading(context);
    }
  }
}
