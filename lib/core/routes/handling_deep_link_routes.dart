import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';

import 'app_routes.dart';

class HandlingDeepLinkRoutes {
  static DeepLinkRoute handleDeepLink(String deepLink) {
    Uri uri = Uri.parse(deepLink);
    if (kDebugMode) {
      print('CURRENT URI HAMADA $uri');
    }
    switch (uri.path) {
     
      case "/bills/bills/":
        return const DeepLinkRoute(
          routeName: AppRoutes.homeRoute,
          arguments: {},
        );

      default:
               return DeepLinkRoute(
          routeName: uri.path == '' ? AppRoutes.homeRoute : deepLink,
          arguments: uri.queryParameters,
        );
    }
  }

  static Map<String, String> extractQueryParameters(String deepLink) {
    Uri uri = Uri.parse(deepLink);
    return uri.queryParameters;
  }

  static Future<void> initAppLinks() async {
    final appLinks = AppLinks(); // AppLinks is singleton

    appLinks.uriLinkStream.listen((uri) {
      final routeName = HandlingDeepLinkRoutes.handleDeepLink(uri.toString()).routeName;
      final query = HandlingDeepLinkRoutes.handleDeepLink(uri.toString()).arguments;
      log('CURRENT ROUTE NAME  ${uri.toString()}');
      AppNavigation.navigatorKey.currentState?.pushNamed(routeName, arguments: query);
    });
  }
}

class DeepLinkRoute {
  final String routeName;
  final Map<String, dynamic> arguments;
  const DeepLinkRoute({required this.routeName, required this.arguments});
}
