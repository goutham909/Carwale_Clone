import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/mock_car_specs.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class EvExplorerScreen extends ConsumerWidget {
  const EvExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final evCars = catalog.cars.where((c) {
          final specs = specsForCar(c.id);
          return specs['Fuel'] == 'Electric' || c.version.toLowerCase().contains('ev') || c.name.toLowerCase().contains('ev');
        }).toList();

        return CwSubpageScaffold(
          title: 'Electric vehicles',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Browse EVs with battery, range, and charging (demo data).',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.45),
              ),
              const SizedBox(height: 16),
              if (evCars.isEmpty)
                const Text('No EVs in mock catalog — add cars with Electric fuel in specs.')
              else
                ...evCars.map((c) {
                  final s = specsForCar(c.id);
                  return Card(
                    color: kCwCard,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => context.pushNamed('car', pathParameters: {'id': c.id}),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.fullName, style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            if (s['Battery'] != null) Text('Battery: ${s['Battery']}', style: const TextStyle(color: kCwMuted)),
                            if (s['Range'] != null) Text('Range: ${s['Range']}', style: const TextStyle(color: kCwMuted)),
                            if (s['Charging'] != null) Text('Charging: ${s['Charging']}', style: const TextStyle(color: kCwMuted)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
