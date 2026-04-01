import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';

class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) => Scaffold(
        key: const Key('screen_compare'),
        backgroundColor: kCwBg,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          title: const Text('Compare Cars', style: TextStyle(fontWeight: FontWeight.w700)),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
            IconButton(icon: const Icon(Icons.bookmark_outline), onPressed: () {}),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(child: _selectBox()),
                      const SizedBox(width: 8),
                      Expanded(child: _selectBox()),
                    ],
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: kCwVsOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('VS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: const Text('+ Add Car'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: kCwCoralCta,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text('Compare', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'POPULAR CAR COMPARISONS',
                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.8, fontSize: 11),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(width: 40, height: 3, decoration: BoxDecoration(color: kCwTeal, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 12),
            ...catalog.comparisons.map((c) => _PopCompareCard(catalog: catalog, pair: c)),
          ],
        ),
      ),
    );
  }
}

Widget _selectBox() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 28),
    decoration: BoxDecoration(
      color: kCwElevated,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: kCwBorder),
    ),
    child: Column(
      children: [
        Icon(Icons.directions_car_outlined, size: 48, color: kCwTeal.withValues(alpha: 0.8)),
        const SizedBox(height: 10),
        const Text('Select Car', style: TextStyle(color: kCwLinkBlue, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _PopCompareCard extends StatelessWidget {
  const _PopCompareCard({required this.catalog, required this.pair});

  final CarWaleCatalog catalog;
  final ComparisonRef pair;

  @override
  Widget build(BuildContext context) {
    final a = catalog.carById(pair.leftId);
    final b = catalog.carById(pair.rightId);
    if (a == null || b == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      decoration: BoxDecoration(
        color: kCwElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kCwBorder),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(child: _half(a)),
              Expanded(child: _half(b)),
            ],
          ),
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kCwVsOrange,
              shape: BoxShape.circle,
              border: Border.all(color: kCwBg, width: 3),
            ),
            child: const Text('VS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

Widget _half(Car c) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        SizedBox(height: 56, child: Image.network(c.imageUrls.first, fit: BoxFit.contain)),
        const SizedBox(height: 8),
        Text('${c.brand} ${c.name}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 4),
        Text(c.priceDisplay, textAlign: TextAlign.center, style: const TextStyle(color: kCwMuted, fontSize: 11)),
      ],
    ),
  );
}
