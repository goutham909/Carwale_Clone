import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

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
                                IconButton(icon: const Icon(Icons.search, size: 22), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.favorite_border, size: 22), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.share_outlined, size: 22), onPressed: () {}),
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
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
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
                                  onPressed: urls.length > 1
                                      ? () => setState(() => _img = (_img - 1 + urls.length) % urls.length)
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                child: IconButton.filledTonal(
                                  style: IconButton.styleFrom(backgroundColor: Colors.white24),
                                  onPressed: urls.length > 1
                                      ? () => setState(() => _img = (_img + 1) % urls.length)
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _MediaBtn(icon: Icons.palette_outlined, label: 'Colors'),
                                _MediaBtn(icon: Icons.image_outlined, label: 'Images'),
                                _MediaBtn(icon: Icons.play_circle_outline, label: 'Videos'),
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
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        foregroundColor: kCwTeal,
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text('32 Reviews', style: TextStyle(fontSize: 13)),
                                    ),
                                    Text(' | Write Review', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9))),
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
                                      Container(width: 1, height: 72, color: kCwBorder),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('City', style: TextStyle(color: kCwMuted, fontSize: 11)),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(child: Text(car.city, style: const TextStyle(fontSize: 12))),
                                                  const Icon(Icons.chevron_right, color: kCwMuted),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      car.priceDisplay.startsWith('Rs') ? car.priceDisplay : 'Rs. ${car.priceDisplay}',
                                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('View Price Breakup', style: TextStyle(color: kCwTeal, fontSize: 14)),
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
                                      const Text('EMI Calculator', style: TextStyle(color: kCwTeal, fontSize: 13)),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(foregroundColor: kCwTeal, side: const BorderSide(color: kCwTeal)),
                                          onPressed: () {},
                                          child: const Text('Get EMI Offers'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: kCwCoralCta,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child: const Text('Get April Offers', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MediaBtn extends StatelessWidget {
  const _MediaBtn({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
