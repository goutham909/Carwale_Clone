import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class ReviewsHubScreen extends ConsumerWidget {
  const ReviewsHubScreen({super.key, required this.carId});

  final String carId;

  static const _demoReviews = [
    ('Rahul K.', 5, 'Great city car. Mileage and service costs are reasonable.'),
    ('Priya M.', 4, 'Comfortable seats. Would love better NVH at highway speeds.'),
    ('Amit S.', 5, 'Bought after comparing on CW — happy with dealer experience.'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final car = catalog.carById(carId);
        return CwSubpageScaffold(
          title: 'Reviews',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (car != null)
                Text(car.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('4.6', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kCwTeal)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('★★★★★', style: TextStyle(letterSpacing: 1)),
                      Text(
                        'Based on 32 owner reviews (demo)',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kCwCoralCta, minimumSize: const Size.fromHeight(46)),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: kCwCard,
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Write a review', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 12),
                          Text(
                            'Sign-in would be required on the real app. This is a UI demo.',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.55)),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Write your review', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 24),
              const Text('Owner reviews', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ..._demoReviews.map(
                (r) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kCwCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kCwBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text('${r.$2}.0 ★', style: const TextStyle(color: kCwTeal)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(r.$3, style: const TextStyle(height: 1.4)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.play_circle_outline, color: kCwTeal),
                title: const Text('Video reviews'),
                subtitle: const Text('5,000+ videos on the real platform — demo shows placeholder'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Would open video list (demo).')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
