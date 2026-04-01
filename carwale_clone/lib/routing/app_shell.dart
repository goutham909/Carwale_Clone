import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCwBg,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: kCwBorder, width: 1)),
        ),
        child: NavigationBar(
        key: const Key('cw_main_nav'),
        height: 64,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: 'New',
          ),
          const NavigationDestination(
            icon: Icon(Icons.manage_search_outlined),
            selectedIcon: Icon(Icons.manage_search),
            label: 'Used',
          ),
          const NavigationDestination(
            icon: Icon(Icons.balance_outlined),
            selectedIcon: Icon(Icons.balance),
            label: 'Compare',
          ),
          const NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            label: 'News',
          ),
          NavigationDestination(
            icon: _badgeIcon(Icons.notifications_outlined),
            selectedIcon: _badgeIcon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
        ),
      ),
    );
  }
}

Widget _badgeIcon(IconData data) {
  return Badge(
    smallSize: 7,
    backgroundColor: const Color(0xFFE84E4E),
    alignment: const Alignment(0.4, -0.7),
    child: Icon(data),
  );
}
