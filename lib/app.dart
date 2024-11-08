import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:linkati/config/app_injector.dart';
import 'package:linkati/features/challenges/presentation/cubit/challenges_cubit.dart';
import 'package:linkati/features/users/presentation/cubit/users_cubit.dart';

import 'core/routes/app_routes.dart';
import 'core/themes/app_themes.dart';
import 'features/links/data/repositories/links_repositories.dart';
import 'features/links/presentation/cubit/links_cubit.dart';
import 'features/users/data/repositories/users_repositories.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          lazy: false,
          create: (__) => UsersCubit(
            repository: instance<UsersRepository>(),
            auth: FirebaseAuth.instance,
          )..fetchMyUserAccount(),
        ),
        RepositoryProvider(
          create: (__) => ChallengesCubit(),
        ),
        RepositoryProvider(
          create: (__) => LinksCubit(
            repository: instance<LinksRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: AppNavigation.navigatorKey,
        initialRoute: AppRoutes.homeRoute,
        onGenerateRoute: AppNavigation.generate,
        debugShowCheckedModeBanner: false,
        title: "Linkati",
        theme: AppThemes.light(),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale("ar", "AE")],
        locale: const Locale("ar", "AE"),
      ),
    );
  }
}