import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/mock_car_specs.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_logo.dart';

class CarDetailScreen extends ConsumerStatefulWidget {
  const CarDetailScreen({super.key, required this.carId});

  final String carId;

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen> {
  int _tab = 0;
  int _img = 0;

  void _openGallery(String mode) {
    context.pushNamed('gallery', pathParameters: {'carId': widget.carId}, queryParameters: {'mode': mode});
  }

  void _showVersionsSheet(Car car) {
    final variants = [
      '${car.name} LXi Petrol MT',
      '${car.name} VXi Petrol MT',
      '${car.name} ZXi Petrol MT',
      '${car.name} ZXi+ AMT',
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kCwCard,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Select version', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
            ...variants.map(
              (v) => ListTile(
                title: Text(v),
                trailing: v.contains(car.version.split(' ').first) ? const Icon(Icons.check, color: kCwTeal) : null,
                onTap: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);
    final saved = ref.watch(savedCarIdsProvider);
    final city = ref.watch(selectedCityProvider);
    final isSaved = saved.contains(widget.carId);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final car = catalog.carById(widget.carId);
        if (car == null) {
          return Scaffold(
            appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
            body: const Center(child: Text('Car not found')),
          );
        }
        final urls = car.imageUrls;
        _img = _img.clamp(0, urls.length - 1);
        final specs = specsForCar(car.id);

        return Scaffold(
          key: const Key('screen_car_detail'),
          backgroundColor: kCwBg,
          body: Stack(
            children: [
              Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                          ),
                          const CwLogoMark(fontSize: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.search, size: 22),
                                  onPressed: () => context.pushNamed('search'),
                                ),
                                IconButton(
                                  icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border, size: 22),
                                  onPressed: () => ref.read(savedCarIdsProvider.notifier).toggle(widget.carId),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share_outlined, size: 22),
                                  onPressed: () async {
                                    await Clipboard.setData(ClipboardData(text: 'https://carwale.clone/demo/${car.id}'));
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Link copied to clipboard (demo).')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(4, (i) {
                        final labels = ['OVERVIEW', 'OFFERS', 'KEY SPECS', 'VERSIONS'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextButton(
                            onPressed: () => setState(() => _tab = i),
                            child: Column(
                              children: [
                                Text(
                                  labels[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 10,
                                    color: _tab == i ? Colors.white : kCwMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2,
                                  width: 72,
                                  color: _tab == i ? kCwTeal : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: _tab == 0
                          ? _overviewTab(
                              context,
                              car: car,
                              urls: urls,
                              city: city,
                              specs: specs,
                            )
                          : _tab == 1
                              ? _offersTab(car)
                              : _tab == 2
                                  ? _specsTab(specs)
                                  : _versionsTab(car),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(14, 12, 14, 12 + MediaQuery.paddingOf(context).bottom),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [kCwBg, kCwBg.withValues(alpha: 0.95), Colors.transparent],
                      stops: const [0, 0.35, 1],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: kCwTeal, side: const BorderSide(color: kCwTeal)),
                        onPressed: () => context.pushNamed('test-drive', pathParameters: {'carId': car.id}),
                        child: const Text('Book test drive'),
                      ),
                      const SizedBox(height: 10),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: kCwCoralCta,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => context.pushNamed('offers', pathParameters: {'carId': car.id}),
                        child: const Text('Get April Offers', style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _overviewTab(
    BuildContext context, {
    required Car car,
    required List<String> urls,
    required String city,
    required Map<String, String> specs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: const Color(0xFF0A0A0A),
              height: 220,
              width: double.infinity,
              child: Image.network(urls[_img], fit: BoxFit.contain),
            ),
            Positioned(
              left: 8,
              child: IconButton.filledTonal(
                style: IconButton.styleFrom(backgroundColor: Colors.white24),
                onPressed: urls.length > 1 ? () => setState(() => _img = (_img - 1 + urls.length) % urls.length) : null,
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            Positioned(
              right: 8,
              child: IconButton.filledTonal(
                style: IconButton.styleFrom(backgroundColor: Colors.white24),
                onPressed: urls.length > 1 ? () => setState(() => _img = (_img + 1) % urls.length) : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            Positioned(
              bottom: 8,
              child: TextButton.icon(
                onPressed: () => _openGallery('exterior'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black54,
                ),
                icon: const Icon(Icons.threesixty, size: 18),
                label: const Text('360° view (demo)'),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MediaBtn(icon: Icons.palette_outlined, label: 'Colors', onTap: () => _openGallery('colors')),
              _MediaBtn(icon: Icons.image_outlined, label: 'Images', onTap: () => _openGallery('images')),
              _MediaBtn(icon: Icons.play_circle_outline, label: 'Videos', onTap: () => _openGallery('videos')),
            ],
          ),
        ),
        const Divider(color: kCwBorder, height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${car.brand} ${car.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [kCwTeal, kCwTealAccent],
                ).createShader(bounds),
                child: const Text('★★★★★', style: TextStyle(letterSpacing: 2, fontSize: 15)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () => context.pushNamed('reviews', pathParameters: {'carId': car.id}),
                    style: TextButton.styleFrom(
                      foregroundColor: kCwTeal,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('32 Reviews', style: TextStyle(fontSize: 13)),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed('reviews', pathParameters: {'carId': car.id}),
                    child: Text(' | Write Review', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9))),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kCwBorder),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showVersionsSheet(car),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Version', style: TextStyle(color: kCwMuted, fontSize: 11)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(child: Text(car.version, style: const TextStyle(fontSize: 13))),
                                    const Icon(Icons.chevron_right, color: kCwMuted),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 72, color: kCwBorder),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.pushNamed('city-picker'),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('City', style: TextStyle(color: kCwMuted, fontSize: 11)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(child: Text(city, style: const TextStyle(fontSize: 12))),
                                    const Icon(Icons.chevron_right, color: kCwMuted),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'On-road prices use $city in this demo.',
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.45)),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      car.priceDisplay.startsWith('Rs') ? car.priceDisplay : 'Rs. ${car.priceDisplay}',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed('on-road', pathParameters: {'carId': car.id}),
                    child: const Text('View Price Breakup', style: TextStyle(color: kCwTeal, fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(car.onRoad, style: const TextStyle(color: kCwMuted, fontSize: 13)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: kCwBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${car.emi} ⓘ',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => context.pushNamed('emi-calculator', queryParameters: {'carId': car.id}),
                      child: const Text('EMI Calculator', style: TextStyle(color: kCwTeal, fontSize: 13)),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: kCwTeal, side: const BorderSide(color: kCwTeal)),
                        onPressed: () => context.pushNamed('loan-offers'),
                        child: const Text('Get EMI Offers'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Quick specs', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...specs.entries.take(4).map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key, style: const TextStyle(color: kCwMuted, fontSize: 13)),
                          Text(e.value, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
              TextButton(
                onPressed: () => setState(() => _tab = 2),
                child: const Text('View all specifications'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _offersTab(Car car) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: kCwCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: kCwBorder)),
            leading: const Icon(Icons.local_offer_outlined, color: kCwTeal),
            title: const Text('April cash discount'),
            subtitle: const Text('Up to ₹ 35,000 on select trims (demo)'),
            onTap: () => context.pushNamed('offers', pathParameters: {'carId': car.id}),
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: kCwCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: kCwBorder)),
            leading: const Icon(Icons.percent_outlined, color: kCwTeal),
            title: const Text('Low EMI scheme'),
            subtitle: const Text('Partner banks from 8.5% p.a.'),
            onTap: () => context.pushNamed('emi-calculator', queryParameters: {'carId': car.id}),
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: kCwCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: kCwBorder)),
            leading: const Icon(Icons.directions_car_outlined, color: kCwTeal),
            title: const Text('Test drive at home'),
            subtitle: const Text('Pick a slot — no obligation'),
            onTap: () => context.pushNamed('test-drive', pathParameters: {'carId': car.id}),
          ),
        ],
      ),
    );
  }

  Widget _specsTab(Map<String, String> specs) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: specs.entries
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kCwBorder))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: const TextStyle(color: kCwMuted)),
                    Flexible(child: Text(e.value, textAlign: TextAlign.right)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _versionsTab(Car car) {
    final variants = [
      ('${car.name} Sigma Petrol MT', '₹ —'),
      ('${car.name} Delta Petrol MT', car.priceRange),
      ('${car.name} Zeta Turbo AT', '₹ —'),
    ];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: variants
            .map(
              (v) => Card(
                color: kCwCard,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(v.$1),
                  subtitle: Text(v.$2),
                  trailing: const Icon(Icons.chevron_right, color: kCwMuted),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected ${v.$1} (demo)')),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MediaBtn extends StatelessWidget {
  const _MediaBtn({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: Colors.white54),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        ],
      ),
    );
  }
}
