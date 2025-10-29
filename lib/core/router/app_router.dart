import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urban_x_app/features/home/presentation/pages/home_page.dart';
import 'package:urban_x_app/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:urban_x_app/features/my_issues/presentation/pages/my_issues_page.dart';
import '../../features/main/presentation/pages/main_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainPage(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: '/my-issues',
          name: 'my_issues',
          builder: (context, state) {
            return const MyIssuesPage();
          },
        ),
        GoRoute(
          path: '/leaderboard',
          name: 'leaderboard',
          builder: (context, state) {
            return const LeaderboardPage();
          },
        ),
      ],
    ),
  ],
);
