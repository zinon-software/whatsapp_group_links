part of 'app_routes.dart';

class AppNavigation {
  AppNavigation._();

  // مفتاح الملاحة العام يستخدم لعرض الشاشات وإدارة التنقل بينها
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Route generate(RouteSettings settings) {
    // ignore: prefer_typing_uninitialized_variables
    final query = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      // start main
      case AppRoutes.homeRoute:
        return _moveRoute(
          settings: settings,
          view: const HomeScreen(),
        );

      case AppRoutes.slideshowFormRoute:
        return _moveRoute(
          settings: settings,
          view: SlideshowFormScreen(
            slideshow: query['slideshow'] as SlideshowModel?,
          ),
        );
      // end main

      // start users
      case AppRoutes.loginRoute:
        return _moveRoute(
          settings: settings,
          view: LoginScreen(
            nextRoute: query['next_route'] as String?,
            returnRoute: query['return_route'] as bool? ?? false,
            queryParameters: query['query_parameters'] as Map<String, dynamic>?,
          ),
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

      case AppRoutes.editAccountRoute:
        return _moveRoute(
          settings: settings,
          view: EditAccountScreen(
            user: query['user'] as UserModel,
          ),
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
          view: const BannedWordsScreen(),
        );

      case AppRoutes.addBannedWordsRoute:
        return _moveRoute(
          settings: settings,
          view: AddBannedWordsScreen(words: query['words'] as List<String>),
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
      case AppRoutes.topicsRoute:
        return _moveRoute(
          settings: settings,
          view: const TopicsScreen(),
        );

      case AppRoutes.topicFormRoute:
        return _moveRoute(
          settings: settings,
          view: TopicFormScreen(
            topic: query['topic'] as TopicModel?,
          ),
        );

      case AppRoutes.gamesRoute:
        return _moveRoute(
          settings: settings,
          view: GamesScreen(
            topic: query['topic'] as TopicModel,
          ),
        );

      case AppRoutes.questionsRoute:
        return _moveRoute(
          settings: settings,
          view: QuestionsScreen(
            topic: query['topic'] as TopicModel,
          ),
        );

      case AppRoutes.questionFormRoute:
        return _moveRoute(
          settings: settings,
          view: QuestionFormScreen(
            question: query['question'] as QuestionModel?,
            topic: query['topic'] as String,
          ),
        );

      case AppRoutes.waitingForPlayerRoute:
        return _moveRoute(
          settings: settings,
          view: WaitingForPlayerScreen(
            game: query['game'] as GameModel,
            questions: query['questions'] as List<QuestionModel>,
          ),
        );

      case AppRoutes.gameRoute:
        return _moveRoute(
          settings: settings,
          view: GameScreen(
            game: query['game'] as GameModel,
            questions: query['questions'] as List<QuestionModel>,
          ),
        );
      // end challenges

      // start qna
      case AppRoutes.qnasRoute:
        return _moveRoute(
          settings: settings,
          view: BlocProvider(
            create: (context) => QnaCubit(
              repository: instance<QnaRepository>(),
            )..fetchQnaQuestionsEvent(),
            child: const QnasScreen(),
          ),
        );

      case AppRoutes.qnaFormRoute:
        return _moveRoute(
          settings: settings,
          view: BlocProvider.value(
            value: QnaCubit(repository: instance<QnaRepository>()),
            child: QnaFormScreen(
              question: query['question'] as QnaQuestionModel?,
            ),
          ),
        );

      case AppRoutes.qnaDetailsRoute:
      QnaQuestionModel? question = query['question'] as QnaQuestionModel?;
        return _moveRoute(
          settings: settings,
          view: BlocProvider.value(
            value: QnaCubit(repository: instance<QnaRepository>()),
            child: QnaDetailsScreen(
              question: question,
              questionId: question?.id ?? query['question_id'] as String,

            ),
          ),
        );

      // end qna

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
