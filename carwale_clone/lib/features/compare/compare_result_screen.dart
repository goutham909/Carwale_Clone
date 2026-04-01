import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/mock_car_specs.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class CompareResultScreen extends ConsumerWidget {
  const CompareResultScreen({super.key, required this.leftId, required this.rightId});

  final String leftId;
  final String rightId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final a = catalog.carById(leftId);
        final b = catalog.carById(rightId);
        if (a == null || b == null) {
          return CwSubpageScaffold(
            title: 'Compare',
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load both cars.'),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: () => context.pop(), child: const Text('Go back')),
                  ],
                ),
              ),
            ),
          );
        }
        final sa = specsForCar(a.id);
        final sb = specsForCar(b.id);
        final keys = {...sa.keys, ...sb.keys}.toList()..sort();

        return CwSubpageScaffold(
          title: 'Comparison',
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(child: _carHead(a)),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(color: kCwVsOrange, borderRadius: BorderRadius.circular(20)),
                        child: const Text('VS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
                      ),
                    ),
                    Expanded(child: _carHead(b)),
                  ],
                ),
              ),
              const Divider(color: kCwBorder),
              ...keys.map((k) {
                final va = sa[k] ?? '—';
                final vb = sb[k] ?? '—';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kCwBorder))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(va, style: const TextStyle(fontSize: 13))),
                      SizedBox(
                        width: 100,
                        child: Text(
                          k.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: kCwMuted, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Expanded(
                        child: Text(vb, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.pushNamed('car', pathParameters: {'id': a.id}),
                        child: const Text('View A'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: kCwCoralCta),
                        onPressed: () => context.pushNamed('car', pathParameters: {'id': b.id}),
                        child: const Text('View B'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _carHead(Car c) {
    return Column(
      children: [
        SizedBox(height: 64, child: Image.network(c.imageUrls.first, fit: BoxFit.contain)),
        const SizedBox(height: 8),
        Text('${c.brand} ${c.name}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 4),
        Text(c.priceDisplay, textAlign: TextAlign.center, style: const TextStyle(color: kCwMuted, fontSize: 11)),
      ],
    );
  }
}
