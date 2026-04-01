import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class OnRoadPriceScreen extends ConsumerWidget {
  const OnRoadPriceScreen({super.key, required this.carId});

  final String carId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);
    final city = ref.watch(selectedCityProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final car = catalog.carById(carId);
        if (car == null) {
          return CwSubpageScaffold(title: 'Price breakup', body: const Center(child: Text('Car not found')));
        }
        final exShowroom = 650000.0;
        final rto = 85000.0;
        final insurance = 42000.0;
        final tcs = 11000.0;
        final onRoad = exShowroom + rto + insurance + tcs;

        String fmt(double v) => '₹ ${v.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

        return CwSubpageScaffold(
          title: 'On-road price',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(car.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Prices shown for $city (demo estimates)', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
              const SizedBox(height: 20),
              _row('Ex-showroom', fmt(exShowroom)),
              _row('RTO & registration', fmt(rto)),
              _row('Comprehensive insurance (1 yr)', fmt(insurance)),
              _row('TCS / other charges', fmt(tcs)),
              const Divider(color: kCwBorder, height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('On-road total', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  Text(fmt(onRoad), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: kCwTeal)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Listed app price: ${car.priceDisplay} · ${car.onRoad}',
                style: const TextStyle(color: kCwMuted, fontSize: 12),
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => context.pushNamed('city-picker'),
                child: const Text('Change city'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kCwCoralCta, minimumSize: const Size.fromHeight(48)),
                onPressed: () => context.pushNamed('dealers'),
                child: const Text('Get dealer quotes', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(k, style: TextStyle(color: Colors.white.withValues(alpha: 0.85)))),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
