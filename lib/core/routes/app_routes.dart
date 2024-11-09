import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_review/in_app_review.dart';

import 'package:flutter/material.dart';
import 'package:linkati/features/links/presentation/pages/link_details_screen.dart';
import 'package:linkati/features/users/presentation/pages/account_screen.dart';

import '../../features/challenges/presentation/pages/challenges_sections_screen.dart';
import '../../features/home_screen.dart';
import '../../features/links/data/models/link_model.dart';
import '../../features/links/presentation/pages/banned_words_screen.dart';
import '../../features/links/presentation/pages/links_dashboard_screen.dart';
import '../../features/links/presentation/pages/link_form_screen.dart';
import '../../features/links/presentation/pages/links_screen.dart';
import '../../features/users/presentation/pages/login_screen.dart';
import '../../features/users/presentation/pages/privacy_policy_screen.dart';

part 'app_navigation.dart';

class AppRoutes {
  AppRoutes._();

  static const String homeRoute = '/';

  // users
  static const String loginRoute = '/login_route';
  static const String accountRoute = '/account_route';
  static const String privacyPolicyRoute = '/privacy_policy_route';

  // links
  static const String linkDetailsRoute = '/link_details_route';
  static const String linkFormRoute = '/link_form_route';
  static const String bannedWordsRoute = '/banned_words_route';
  static const String linksDashboardRoute = '/links_dashboard_route';
  static const String linksRoute = '/links_route';

  // challenges
  static const String challengesSectionsRoute = '/challenges_sections_route';
}
