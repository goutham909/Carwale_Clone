import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class UsedListingsScreen extends ConsumerWidget {
  const UsedListingsScreen({super.key, this.cityFilter});

  final String? cityFilter;

  static const _mock = [
    ('2019 Hyundai Creta SX', '42,000 km · Petrol · AT', '₹ 9.85 Lakh', 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=400'),
    ('2021 Kia Seltos HTK', '28,000 km · Diesel · MT', '₹ 11.20 Lakh', 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=400'),
    ('2018 Maruti Baleno Alpha', '55,000 km · Petrol · CVT', '₹ 5.90 Lakh', 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=400'),
    ('2020 Tata Nexon XZ+', '35,000 km · Diesel · AMT', '₹ 8.45 Lakh', 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=400'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = cityFilter ?? ref.watch(selectedCityProvider);

    return CwSubpageScaffold(
      title: 'Used cars',
      actions: [
        TextButton(
          onPressed: () => context.push('/sell-car'),
          child: const Text('Sell', style: TextStyle(color: kCwTeal)),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Text('$city · ${_mock.length} verified listings (demo)', style: const TextStyle(color: kCwMuted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, 'Budget'),
              _chip(context, 'Body type'),
              _chip(context, 'Fuel'),
              ActionChip(
                label: const Text('Valuation tool'),
                onPressed: () => context.push('/valuation'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._mock.map(
            (u) => Card(
              color: kCwCard,
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: kCwCard,
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.$1, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text(u.$2),
                          const SizedBox(height: 8),
                          Text(u.$3, style: const TextStyle(color: kCwTeal, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Contact seller (demo)'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(u.$4, width: 96, height: 72, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(u.$2, style: const TextStyle(color: kCwMuted, fontSize: 12)),
                            const SizedBox(height: 6),
                            Text(u.$3, style: const TextStyle(color: kCwTeal, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: kCwMuted),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _chip(BuildContext context, String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label filter — demo (would open sheet).')),
        );
      },
    );
  }
}
