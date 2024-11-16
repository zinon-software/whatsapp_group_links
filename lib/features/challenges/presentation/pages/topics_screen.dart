import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/core/widgets/custom_skeletonizer_widget.dart';

import '../../../../core/ads/ads_manager.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/color_manager.dart';
import '../../../users/presentation/cubit/users_cubit.dart';
import '../../data/models/topic_model.dart';
import '../cubit/challenges_cubit.dart';
import '../widgets/topic_card_widget.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late final UsersCubit _usersCubit;
  late final ChallengesCubit _challengesCubit;
  late final AdsManager _adsManager;

  @override
  void initState() {
    _usersCubit = context.read<UsersCubit>();
    _challengesCubit = context.read<ChallengesCubit>();
    super.initState();
    _challengesCubit.fetchTopicsEvent();
    _adsManager = AdsManager();
    _adsManager.loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة التحديات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _challengesCubit.fetchTopicsEvent();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _challengesCubit.fetchTopicsEvent(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<ChallengesCubit, ChallengesState>(
            bloc: _challengesCubit,
            buildWhen: (previous, current) =>
                current is FetchTopicsSuccessState ||
                current is FetchTopicsLoadingState ||
                current is FetchTopicsErrorState,
            builder: (context, state) {
              if (state is FetchTopicsLoadingState) {
                return CustomSkeletonizerWidget(
                  enabled: true,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return TopicCardWidget(
                        topic: TopicModel.empty(),
                        usersCubit: _usersCubit,
                        adsManager: _adsManager,
                      );
                    },
                  ),
                );
              }
              if (state is FetchTopicsErrorState) {
                return Center(
                  child: Text(state.failure),
                );
              }
              final topics = (state is FetchTopicsSuccessState)
                  ? state.topics
                  : _challengesCubit.topics;
              if (topics.isEmpty) {
                return const Center(
                  child: Text("لا يوجد تحديات"),
                );
              }
              return ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final TopicModel topic = topics[index];

                  return TopicCardWidget(
                    topic: topic,
                    usersCubit: _usersCubit,
                    adsManager: _adsManager,
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton:
          _usersCubit.currentUser?.permissions.isAdmin ?? false
              ? FloatingActionButton(
                  backgroundColor: ColorsManager.primaryLight,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(
                          AppRoutes.topicFormRoute,
                        )
                        .then((value) => _challengesCubit.fetchTopicsEvent());
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
