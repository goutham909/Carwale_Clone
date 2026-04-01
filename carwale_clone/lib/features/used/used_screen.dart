import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_logo.dart';

class UsedScreen extends ConsumerStatefulWidget {
  const UsedScreen({super.key});

  @override
  ConsumerState<UsedScreen> createState() => _UsedScreenState();
}

class _UsedScreenState extends ConsumerState<UsedScreen> {
  double _min = 0;
  double _max = 20;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) => Scaffold(
        key: const Key('screen_used'),
        backgroundColor: kCwBg,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                    child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
                      const Expanded(child: Center(child: CwLogoMark(fontSize: 16))),
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
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Image.network(
                'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=900&q=85',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 200, color: kCwCard),
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -16),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kCwElevated,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    border: Border.all(color: kCwBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'FIND THE RIGHT USED CAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5, fontSize: 13),
                      ),
                      const SizedBox(height: 18),
                      const Text('Choose your Budget', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: kCwTealAccent,
                          inactiveTrackColor: kCwBorder,
                          rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 11, elevation: 0),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                        ),
                        child: RangeSlider(
                          values: RangeValues(_min, _max),
                          min: 0,
                          max: 20,
                          divisions: 20,
                          onChanged: (v) => setState(() {
                            _min = v.start;
                            _max = v.end;
                          }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Any', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                          Text('20+ Lakh', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _LakhBox(text: _min <= 0 ? '0 Lakh' : '${_min.round()} Lakh'),
                          ),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('—')),
                          Expanded(
                            child: _LakhBox(text: _max >= 20 ? '1000 Lakh' : '${_max.round()} Lakh'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: kCwCoralCta,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {},
                        child: const Text('Find Used Car', style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14, 8, 14, 12),
                child: Text('Used Cars By City', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 92,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: catalog.cities.length,
                  itemBuilder: (context, i) {
                    final c = catalog.cities[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        width: 88,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                          color: kCwCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kCwBorder),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_outlined, color: kCwTeal.withValues(alpha: 0.95), size: 32),
                            const SizedBox(height: 6),
                            Text(
                              c,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _LakhBox extends StatelessWidget {
  const _LakhBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kCwCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kCwBorder),
      ),
      child: Text(text),
    );
  }
}
