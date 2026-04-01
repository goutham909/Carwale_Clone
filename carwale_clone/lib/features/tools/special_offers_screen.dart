import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class SpecialOffersScreen extends ConsumerWidget {
  const SpecialOffersScreen({super.key, required this.carId});

  final String carId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final car = catalog.carById(carId);
        return CwSubpageScaffold(
          title: 'April offers',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (car != null) ...[
                Text(car.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
              ],
              _offerCard('Cash discount', 'Up to ₹ 35,000 on select variants (demo).'),
              _offerCard('Exchange bonus', 'Additional ₹ 15,000 on old car exchange.'),
              _offerCard('Corporate benefit', 'Special pricing for eligible employers.'),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kCwTeal, minimumSize: const Size.fromHeight(48)),
                onPressed: () => context.pushNamed('test-drive', pathParameters: {'carId': carId}),
                child: const Text('Book test drive', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => context.pushNamed('dealers'),
                child: const Text('Contact nearest dealer'),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _offerCard(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCwCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kCwBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: kCwMuted, height: 1.4)),
        ],
      ),
    );
  }
}
