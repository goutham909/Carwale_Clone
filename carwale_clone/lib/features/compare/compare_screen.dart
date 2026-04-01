import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';

class CompareScreen extends ConsumerStatefulWidget {
  const CompareScreen({super.key});

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  String? _leftId;
  String? _rightId;

  void _pickCar({required bool isLeft}) {
    final async = ref.read(catalogProvider);
    if (!async.hasValue) return;
    final catalog = async.requireValue;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kCwCard,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.9,
          minChildSize: 0.35,
          builder: (_, scroll) {
            return ListView(
              controller: scroll,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Select car', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                ...catalog.cars.map(
                  (c) => ListTile(
                    leading: SizedBox(
                      width: 48,
                      child: Image.network(c.imageUrls.first, fit: BoxFit.contain),
                    ),
                    title: Text(c.fullName),
                    subtitle: Text(c.priceDisplay, style: const TextStyle(color: kCwMuted, fontSize: 12)),
                    onTap: () {
                      setState(() {
                        if (isLeft) {
                          _leftId = c.id;
                        } else {
                          _rightId = c.id;
                        }
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _runCompare() {
    if (_leftId == null || _rightId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select two cars to compare.')),
      );
      return;
    }
    if (_leftId == _rightId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick two different models.')),
      );
      return;
    }
    context.pushNamed(
      'compare-result',
      queryParameters: {'left': _leftId!, 'right': _rightId!},
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) => Scaffold(
        key: const Key('screen_compare'),
        backgroundColor: kCwBg,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => context.pushNamed('more')),
          title: const Text('Compare Cars', style: TextStyle(fontWeight: FontWeight.w700)),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () => context.pushNamed('search')),
            IconButton(icon: const Icon(Icons.bookmark_outline), onPressed: () => context.pushNamed('saved-cars')),
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
                      Expanded(child: _selectBox(catalog: catalog, id: _leftId, onTap: () => _pickCar(isLeft: true))),
                      const SizedBox(width: 8),
                      Expanded(child: _selectBox(catalog: catalog, id: _rightId, onTap: () => _pickCar(isLeft: false))),
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
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: kCwCard,
                          builder: (ctx) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('Set left car'),
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    _pickCar(isLeft: true);
                                  },
                                ),
                                ListTile(
                                  title: const Text('Set right car'),
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    _pickCar(isLeft: false);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                      onPressed: _runCompare,
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

Widget _selectBox({required CarWaleCatalog catalog, required String? id, required VoidCallback onTap}) {
  final car = id != null ? catalog.carById(id) : null;
  return Material(
    color: kCwElevated,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kCwBorder),
        ),
        child: car == null
            ? Column(
                children: [
                  Icon(Icons.directions_car_outlined, size: 48, color: kCwTeal.withValues(alpha: 0.8)),
                  const SizedBox(height: 10),
                  const Text('Select Car', style: TextStyle(color: kCwLinkBlue, fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              )
            : Column(
                children: [
                  SizedBox(height: 52, child: Image.network(car.imageUrls.first, fit: BoxFit.contain)),
                  const SizedBox(height: 8),
                  Text(
                    '${car.brand} ${car.name}',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(car.priceDisplay, textAlign: TextAlign.center, style: const TextStyle(color: kCwMuted, fontSize: 10)),
                ],
              ),
      ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Material(
        color: kCwElevated,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => context.pushNamed(
            'compare-result',
            queryParameters: {'left': pair.leftId, 'right': pair.rightId},
          ),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
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
          ),
        ),
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
