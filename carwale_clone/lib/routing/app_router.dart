import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/alerts/alerts_screen.dart';
import '../features/car_detail/car_detail_screen.dart';
import '../features/compare/compare_screen.dart';
import '../features/new_home/new_home_screen.dart';
import '../features/news/news_screen.dart';
import '../features/search/search_screen.dart';
import '../features/used/used_screen.dart';
import 'app_shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/new',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/new',
                name: 'new',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const NewHomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/used',
                name: 'used',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const UsedScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/compare',
                name: 'compare',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const CompareScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/news',
                name: 'news',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const NewsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/alerts',
                name: 'alerts',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const AlertsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/car/:id',
        name: 'car',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CarDetailScreen(carId: id);
        },
      ),
    ],
  );
});
