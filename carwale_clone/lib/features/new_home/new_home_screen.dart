import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_logo.dart';

class NewHomeScreen extends ConsumerWidget {
  const NewHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('Failed to load: $e'))),
      data: (catalog) => Scaffold(
        key: const Key('screen_new_home'),
        backgroundColor: kCwBg,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _CwHeader(showHeart: true)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.pushNamed('search'),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: kCwCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Search for your car e.g. Creta',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 15),
                              ),
                            ),
                            Icon(Icons.search, color: Colors.white.withValues(alpha: 0.65)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14, 0, 14, 10),
                  child: Text(
                    'Find The Right Car By',
                    style: TextStyle(color: kCwMuted, fontSize: 13),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: const [
                      _FilterChip(label: 'Budget', icon: Icons.sell_outlined),
                      SizedBox(width: 10),
                      _FilterChip(label: 'Body Type', icon: Icons.directions_car_outlined),
                      SizedBox(width: 10),
                      _FilterChip(label: 'Fuel Type', icon: Icons.local_gas_station_outlined),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: _PromoBanner()),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(14, 8, 14, 12),
                  child: Text(
                    'Recently Viewed Cars',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 168,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    itemCount: catalog.recentCarIds.length,
                    itemBuilder: (context, i) {
                      final id = catalog.recentCarIds[i];
                      final car = catalog.carById(id);
                      if (car == null) return const SizedBox.shrink();
                      return _RecentCarCard(car: car);
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CwHeader extends StatelessWidget {
  const _CwHeader({required this.showHeart});

  final bool showHeart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          const Expanded(child: Center(child: CwLogoMark())),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(icon: const Icon(Icons.location_on_outlined), onPressed: () {}),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: kCwCoral, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          if (showHeart) IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kCwCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kCwBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: kCwTeal),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.white)),
        ],
      ),
    );
  }
}

/// Citroën Basalt–style hero from reference screenshots.
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1533473358331-0135ef3b15aa?w=900&q=85',
              height: 232,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 232,
                color: kCwCard,
                alignment: Alignment.center,
                child: const Text('Ad image', style: TextStyle(color: kCwMuted)),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.92),
                    ],
                    stops: const [0, 0.35, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('Ad', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CITROËN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withValues(alpha: 0.95),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, height: 1.2),
                      children: [
                        const TextSpan(text: 'THE NEW '),
                        TextSpan(
                          text: 'BASALT',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        const TextSpan(text: ' SUV COUPE'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: kCwCoralCta,
                    child: const Text(
                      'STARTS AT ₹ 8.55 LAKH*',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'BENEFITS UP TO ₹ 1.15 LAKH*\n0%* DOWN PAYMENT. 100%* ON-ROAD FUNDING.',
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.35,
                            color: Colors.white.withValues(alpha: 0.88),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: kCwCoralCta,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Text('GET OFFERS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentCarCard extends StatelessWidget {
  const _RecentCarCard({required this.car});

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.pushNamed('car', pathParameters: {'id': car.id}),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 144,
            decoration: BoxDecoration(
              color: kCwCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kCwBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      car.imageUrls.first,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, size: 48, color: kCwMuted),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(car.brand, style: const TextStyle(color: kCwMuted, fontSize: 11)),
                      Text(car.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
