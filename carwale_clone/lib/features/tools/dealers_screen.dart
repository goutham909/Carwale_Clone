import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class DealersScreen extends ConsumerWidget {
  const DealersScreen({super.key});

  static const _dealers = [
    ('Silpa Gram Motors', 'Hyderabad · 4.2 ★ · Verified'),
    ('Cyberabad Auto World', 'Hyderabad · 4.5 ★ · Verified'),
    ('Hitech City Cars', 'Hyderabad · 4.0 ★ · Verified'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider);

    return CwSubpageScaffold(
      title: 'Dealers',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Showing verified dealers near $city (demo).', style: TextStyle(color: Colors.white.withValues(alpha: 0.55))),
          const SizedBox(height: 16),
          ..._dealers.map(
            (d) => Card(
              color: kCwCard,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(d.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(d.$2),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone, color: kCwTeal),
                      onPressed: () async {
                        await Clipboard.setData(const ClipboardData(text: '+91 98765 43210'));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Dealer number copied (demo).')),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.directions, color: kCwTeal),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Would open maps (demo).')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
