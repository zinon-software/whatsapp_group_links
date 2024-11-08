import 'package:in_app_review/in_app_review.dart';

import 'package:flutter/material.dart';
import 'package:linkati/features/links/presentation/pages/link_details_screen.dart';

import '../../features/home_screen.dart';
import '../../features/links/data/models/link_model.dart';
import '../../features/links/presentation/pages/link_form_screen.dart';
import '../../features/users/presentation/pages/login_screen.dart';

part 'app_navigation.dart';

class AppRoutes{
  AppRoutes._();

  static const String homeRoute = '/';
  static const String loginRoute = '/login_route';

  static const String linkDetailsRoute = '/link_details_route';
  static const String linkFormRoute = '/link_form_route';



}