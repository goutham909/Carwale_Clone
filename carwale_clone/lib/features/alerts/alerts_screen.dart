import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) => Scaffold(
        key: const Key('screen_alerts'),
        backgroundColor: kCwBg,
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w700)),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('Clear All', style: TextStyle(color: kCwTeal, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: catalog.notifications.length,
          separatorBuilder: (_, __) => const Divider(color: kCwBorder, height: 1),
          itemBuilder: (context, i) {
            final n = catalog.notifications[i];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(n.imageUrl, width: 100, height: 56, fit: BoxFit.cover),
              ),
              title: Text(n.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(n.time, style: const TextStyle(color: kCwMuted, fontSize: 12)),
              ),
            );
          },
        ),
      ),
    );
  }
}
