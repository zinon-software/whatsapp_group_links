import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/features/links/presentation/pages/link_details_screen.dart';
import 'package:linkati/features/users/presentation/pages/account_screen.dart';

import '../../features/challenges/data/models/game_model.dart';
import '../../features/challenges/data/models/question_model.dart';
import '../../features/challenges/data/models/topic_model.dart';
import '../../features/challenges/presentation/pages/game_screen.dart';
import '../../features/challenges/presentation/pages/games_screen.dart';
import '../../features/challenges/presentation/pages/question_form_screen.dart';
import '../../features/challenges/presentation/pages/questions_screen.dart';
import '../../features/challenges/presentation/pages/topic_form_screen.dart';
import '../../features/challenges/presentation/pages/topics_screen.dart';
import '../../features/challenges/presentation/pages/waiting_for_player_screen.dart';
import '../../features/links/data/models/link_model.dart';
import '../../features/links/presentation/pages/banned_words_screen.dart';
import '../../features/links/presentation/pages/link_form_screen.dart';
import '../../features/links/presentation/pages/links_dashboard_screen.dart';
import '../../features/links/presentation/pages/links_screen.dart';
import '../../features/main/data/models/slideshow_model.dart';
import '../../features/main/presentation/pages/home_screen.dart';
import '../../features/main/presentation/pages/slideshow_form_screen.dart';
import '../../features/qna/data/models/qna_question_model.dart';
import '../../features/qna/data/repositories/qna_repositories.dart';
import '../../features/qna/presentation/cubit/qna_cubit.dart';
import '../../features/qna/presentation/pages/qna_details_screen.dart';
import '../../features/qna/presentation/pages/qna_form_screen.dart';
import '../../features/qna/presentation/pages/qnas_screen.dart';
import '../../features/users/data/models/user_model.dart';
import '../../features/users/presentation/pages/edit_account_screen.dart';
import '../../features/users/presentation/pages/login_screen.dart';
import '../../features/users/presentation/pages/privacy_policy_screen.dart';
import '../../features/users/presentation/pages/users_rank_screen.dart';

part 'app_navigation.dart';

class AppRoutes {
  AppRoutes._();

  // main
  static const String homeRoute = '/';
  static const String slideshowFormRoute = '/slideshow_form_route';

  // users
  static const String loginRoute = '/login_route';
  static const String accountRoute = '/account_route';
  static const String privacyPolicyRoute = '/privacy_policy_route';
  static const String usersRankRoute = '/users_rank_route';
  static const String editAccountRoute = '/edit_account_route';

  // links
  static const String linkDetailsRoute = '/link_details_route';
  static const String linkFormRoute = '/link_form_route';
  static const String bannedWordsRoute = '/banned_words_route';
  static const String linksDashboardRoute = '/links_dashboard_route';
  static const String linksRoute = '/links_route';

  // challenges
  static const String topicsRoute = '/topics_route';
  static const String topicFormRoute = '/topic_form_route';
  static const String gamesRoute = '/games_route';
  static const String questionsRoute = '/questions_route';
  static const String questionFormRoute = '/question_form_route';
  static const String waitingForPlayerRoute = '/waiting_for_player_route';
  static const String gameRoute = '/game_route';

  // qna
  static const String qnasRoute = '/qnas_route';
  static const String qnaFormRoute = '/qna_form_route';
  static const String qnaDetailsRoute = '/qna_details_route';

}
