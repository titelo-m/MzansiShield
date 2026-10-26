import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/link_checker/presentation/link_checker_screen.dart';
import '../../features/password_check/presentation/password_check_screen.dart';
import '../../features/safety_tips/presentation/safety_tips_screen.dart';
import '../../features/report_scam/presentation/report_scam_screen.dart';
import '../../shared/widgets/main_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(
          currentPath: state.uri.path,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/link-checker',
          builder: (context, state) => const LinkCheckerScreen(),
        ),
        GoRoute(
          path: '/password-check',
          builder: (context, state) => const PasswordCheckScreen(),
        ),
        GoRoute(
          path: '/safety-tips',
          builder: (context, state) => const SafetyTipsScreen(),
        ),
        GoRoute(
          path: '/report-scam',
          builder: (context, state) => const ReportScamScreen(),
        ),
      ],
    ),
  ],
);