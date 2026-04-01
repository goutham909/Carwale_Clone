import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants.dart';
import 'routing/app_router.dart';

class CarWaleCloneApp extends ConsumerWidget {
  const CarWaleCloneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'CarWale Clone',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: router,
    );
  }
}

ThemeData _buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: kCwTeal,
      onPrimary: Colors.white,
      secondary: kCwCoral,
      onSecondary: Colors.white,
      surface: kCwElevated,
      onSurface: Colors.white,
      outline: kCwBorder,
    ),
    scaffoldBackgroundColor: kCwBg,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: kCwBg,
      foregroundColor: Colors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: kCwBg,
      indicatorColor: kCwTeal.withValues(alpha: 0.25),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: kCwTeal, fontWeight: FontWeight.w600, fontSize: 11);
        }
        return const TextStyle(color: kCwMuted, fontSize: 11);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: kCwTeal);
        }
        return const IconThemeData(color: kCwMuted);
      }),
    ),
  );
  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
  );
}
