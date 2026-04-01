import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider);

    return CwSubpageScaffold(
      title: 'Menu',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _tile(context, Icons.electric_car_outlined, 'Electric vehicles', () => context.pushNamed('ev')),
          _tile(context, Icons.calculate_outlined, 'EMI calculator', () => context.pushNamed('emi-calculator')),
          _tile(context, Icons.account_balance_outlined, 'Car loan partners', () => context.pushNamed('loan-offers')),
          _tile(context, Icons.storefront_outlined, 'Find dealers', () => context.pushNamed('dealers')),
          _tile(context, Icons.favorite_outline, 'Saved cars', () => context.pushNamed('saved-cars')),
          _tile(context, Icons.location_on_outlined, 'Change city ($city)', () => context.pushNamed('city-picker')),
          const Divider(color: kCwBorder),
          _tile(context, Icons.directions_car_outlined, 'Sell your car', () => context.pushNamed('sell-car')),
          _tile(context, Icons.price_change_outlined, 'Used car valuation', () => context.pushNamed('valuation')),
          _tile(context, Icons.description_outlined, 'RC transfer assistance', () => context.pushNamed('rc-assistance')),
          _tile(context, Icons.search, 'Browse used cars', () => context.pushNamed('used-listings')),
          const Divider(color: kCwBorder),
          _tile(context, Icons.privacy_tip_outlined, 'Privacy & data', () => context.pushNamed('privacy')),
        ],
      ),
    );
  }
}

Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: kCwTeal),
    title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
    trailing: const Icon(Icons.chevron_right, color: kCwMuted),
    onTap: onTap,
  );
}
