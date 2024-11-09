part of 'app_routes.dart';

class AppNavigation {
  AppNavigation._();

  // مفتاح الملاحة العام يستخدم لعرض الشاشات وإدارة التنقل بينها
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route generate(RouteSettings settings) {
    // ignore: prefer_typing_uninitialized_variables
    final query = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case AppRoutes.homeRoute:
        return _moveRoute(
          settings: settings,
          view: const HomeScreen(),
        );

      // start users
      case AppRoutes.loginRoute:
        return _moveRoute(
          settings: settings,
          view: const LoginScreen(),
        );

      case AppRoutes.accountRoute:
        return _moveRoute(
          settings: settings,
          view: const AccountScreen(),
        );

      case AppRoutes.privacyPolicyRoute:
        return _moveRoute(
          settings: settings,
          view: const PrivacyPolicyScreen(),
        );

      case AppRoutes.usersRankRoute:
        return _moveRoute(
          settings: settings,
          view: const UsersRankScreen(),
        );

      // end users

      // start links
      case AppRoutes.linkFormRoute:
        return _moveRoute(
          settings: settings,
          view: LinkFormScreen(
            link: query['link'] as LinkModel?,
          ),
        );

      case AppRoutes.linkDetailsRoute:
        return _moveRoute(
          settings: settings,
          view: LinkDetailsScreen(
            link: query['link'] as LinkModel,
          ),
        );

      case AppRoutes.bannedWordsRoute:
        return _moveRoute(
          settings: settings,
          view: BannedWordsScreen(words: query['words'] as List<String>),
        );

      case AppRoutes.linksDashboardRoute:
        return _moveRoute(
          settings: settings,
          view: const LinksDashboardScreen(),
        );

      case AppRoutes.linksRoute:
        return _moveRoute(
          settings: settings,
          view: LinksScreen(
            title: query['title'] as String,
            query: query['query'] as Query<Object?>,
          ),
        );

      // end links

      // start challenges
      case AppRoutes.sectionsRoute:
        return _moveRoute(
          settings: settings,
          view: const SectionsScreen(),
        );

      case AppRoutes.challengesDashboardRoute:
        return _moveRoute(
          settings: settings,
          view: const ChallengesDashboardScreen(),
        );

      case AppRoutes.sectionFormRoute:
        return _moveRoute(
          settings: settings,
          view: SectionFormScreen(
            section: query['section'] as SectionModel?,
          ),
        );
      // end challenges

      default:
        return _moveRoute(
          settings: settings,
          view: NoRouteFound(routeName: settings.name ?? ''),
        );
    }
  }

  static PageRoute _moveRoute({
    required Widget view,
    required RouteSettings settings,
  }) {
    appReview();

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

appReview() async {
  final InAppReview inAppReview = InAppReview.instance;

  if (await inAppReview.isAvailable()) {
    inAppReview.requestReview();
  }
}

class NoRouteFound extends StatelessWidget {
  const NoRouteFound({super.key, required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "لم يتم العثور على الصفحة\n$routeName",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
