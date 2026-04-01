import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class SavedCarsScreen extends ConsumerWidget {
  const SavedCarsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);
    final saved = ref.watch(savedCarIdsProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final cars = saved.map(catalog.carById).whereType<Car>().toList();
        return CwSubpageScaffold(
          title: 'Saved cars',
          actions: [
            if (saved.isNotEmpty)
              TextButton(
                onPressed: () => ref.read(savedCarIdsProvider.notifier).clear(),
                child: const Text('Clear', style: TextStyle(color: kCwTeal)),
              ),
          ],
          body: cars.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No saved cars yet.\nTap the heart on a car detail page to shortlist.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.5),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: cars.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final car = cars[i];
                    return Material(
                      color: kCwCard,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => context.pushNamed('car', pathParameters: {'id': car.id}),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 88,
                                height: 56,
                                child: Image.network(car.imageUrls.first, fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(car.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(car.priceDisplay, style: const TextStyle(color: kCwMuted, fontSize: 13)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: kCwMuted),
                                onPressed: () => ref.read(savedCarIdsProvider.notifier).toggle(car.id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
