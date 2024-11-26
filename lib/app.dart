import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/features/challenges/data/repositories/challenges_repositories.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';
import 'package:linkati/features/main/presentation/cubit/main_cubit.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import 'core/routes/app_routes.dart';
import 'core/themes/app_themes.dart';
import 'features/links/data/repositories/links_repositories.dart';
import 'features/links/presentation/cubit/links_cubit.dart';
import 'features/main/data/repositories/main_repositories.dart';
import 'features/users/data/repositories/users_repositories.dart';

class App extends StatelessWidget {
  const App({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(411, 866),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (__, child) {
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<UsersCubit>(
                lazy: false,
                create: (__) => UsersCubit(
                  repository: instance<UsersRepository>(),
                  auth: FirebaseAuth.instance,
                )
                  ..fetchMyUserAccount()
                  ..fetchUsersEvent(),
              ),
              RepositoryProvider<ChallengesCubit>(
                create: (__) => ChallengesCubit(
                  repository: instance<ChallengesRepository>(),
                ),
              ),
              RepositoryProvider<LinksCubit>(
                create: (__) => LinksCubit(
                  repository: instance<LinksRepository>(),
                ),
              ),
              RepositoryProvider<MainCubit>(
                lazy: false,
                create: (__) => MainCubit(
                  repository: instance<MainRepository>(),
                )
                  ..fetchLocalSlideshowsEvint()
                  ..fetchRemoteSlideshowsEvint(),
              ),
            ],
            child: MaterialApp(
              navigatorKey: AppNavigation.navigatorKey,
              initialRoute: AppRoutes.homeRoute,
              onGenerateRoute: AppNavigation.generate,
              debugShowCheckedModeBanner: false,
              title: "Linkati",
              theme: AppThemes.light(),
              navigatorObservers: <NavigatorObserver>[observer],
              localizationsDelegates: const [
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale("ar", "AE")],
              locale: const Locale("ar", "AE"),
            ),
          );
        });
  }
}
