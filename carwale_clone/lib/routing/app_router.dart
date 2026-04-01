import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/alerts/alerts_screen.dart';
import '../features/car_detail/car_detail_screen.dart';
import '../features/city/city_picker_screen.dart';
import '../features/compare/compare_result_screen.dart';
import '../features/compare/compare_screen.dart';
import '../features/menu/main_menu_screen.dart';
import '../features/new_home/new_home_screen.dart';
import '../features/news/news_detail_screen.dart';
import '../features/news/news_screen.dart';
import '../features/saved/saved_cars_screen.dart';
import '../features/search/new_car_filter_screen.dart';
import '../features/search/search_screen.dart';
import '../features/settings/privacy_screen.dart';
import '../features/tools/dealers_screen.dart';
import '../features/tools/emi_calculator_screen.dart';
import '../features/tools/ev_explorer_screen.dart';
import '../features/tools/gallery_hub_screen.dart';
import '../features/tools/loan_offers_screen.dart';
import '../features/tools/on_road_price_screen.dart';
import '../features/tools/reviews_hub_screen.dart';
import '../features/tools/special_offers_screen.dart';
import '../features/tools/test_drive_screen.dart';
import '../features/used/rc_assistance_screen.dart';
import '../features/used/sell_car_screen.dart';
import '../features/used/used_listings_screen.dart';
import '../features/used/used_screen.dart';
import '../features/used/valuation_screen.dart';
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
        builder: (context, state) => SearchScreen(
          initialQuery: state.uri.queryParameters['q'],
        ),
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
      GoRoute(
        path: '/more',
        name: 'more',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: '/city-picker',
        name: 'city-picker',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const CityPickerScreen(),
      ),
      GoRoute(
        path: '/saved-cars',
        name: 'saved-cars',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SavedCarsScreen(),
      ),
      GoRoute(
        path: '/emi-calculator',
        name: 'emi-calculator',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final carId = state.uri.queryParameters['carId'];
          return EmiCalculatorScreen(initialCarId: carId);
        },
      ),
      GoRoute(
        path: '/on-road/:carId',
        name: 'on-road',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final carId = state.pathParameters['carId']!;
          return OnRoadPriceScreen(carId: carId);
        },
      ),
      GoRoute(
        path: '/test-drive/:carId',
        name: 'test-drive',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final carId = state.pathParameters['carId']!;
          return TestDriveScreen(carId: carId);
        },
      ),
      GoRoute(
        path: '/offers/:carId',
        name: 'offers',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final carId = state.pathParameters['carId']!;
          return SpecialOffersScreen(carId: carId);
        },
      ),
      GoRoute(
        path: '/loan-offers',
        name: 'loan-offers',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const LoanOffersScreen(),
      ),
      GoRoute(
        path: '/gallery/:carId',
        name: 'gallery',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final carId = state.pathParameters['carId']!;
          final mode = state.uri.queryParameters['mode'] ?? 'images';
          return GalleryHubScreen(carId: carId, mode: mode);
        },
      ),
      GoRoute(
        path: '/reviews/:carId',
        name: 'reviews',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final carId = state.pathParameters['carId']!;
          return ReviewsHubScreen(carId: carId);
        },
      ),
      GoRoute(
        path: '/ev',
        name: 'ev',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const EvExplorerScreen(),
      ),
      GoRoute(
        path: '/dealers',
        name: 'dealers',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const DealersScreen(),
      ),
      GoRoute(
        path: '/used-listings',
        name: 'used-listings',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final city = state.uri.queryParameters['city'];
          return UsedListingsScreen(cityFilter: city);
        },
      ),
      GoRoute(
        path: '/sell-car',
        name: 'sell-car',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SellCarScreen(),
      ),
      GoRoute(
        path: '/valuation',
        name: 'valuation',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ValuationScreen(),
      ),
      GoRoute(
        path: '/rc-assistance',
        name: 'rc-assistance',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const RcAssistanceScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/news/:articleId',
        name: 'news-detail',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final id = state.pathParameters['articleId']!;
          return NewsDetailScreen(articleId: id);
        },
      ),
      GoRoute(
        path: '/compare-result',
        name: 'compare-result',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final left = state.uri.queryParameters['left'] ?? '';
          final right = state.uri.queryParameters['right'] ?? '';
          return CompareResultScreen(leftId: left, rightId: right);
        },
      ),
      GoRoute(
        path: '/filter/new',
        name: 'filter-new',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'budget';
          return NewCarFilterScreen(filterType: type);
        },
      ),
    ],
  );
});
