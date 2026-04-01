import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  List<AppNotification>? _items;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        _items ??= List<AppNotification>.from(catalog.notifications);
        final list = _items!;

        return Scaffold(
          key: const Key('screen_alerts'),
          backgroundColor: kCwBg,
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.menu), onPressed: () => context.pushNamed('more')),
            title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w700)),
            actions: [
              TextButton(
                onPressed: list.isEmpty
                    ? null
                    : () => setState(() => _items = []),
                child: const Text('Clear All', style: TextStyle(color: kCwTeal, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          body: list.isEmpty
              ? Center(
                  child: Text(
                    'You are all caught up.',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
                  ),
                )
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(color: kCwBorder, height: 1),
                  itemBuilder: (context, i) {
                    final n = list[i];
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
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: kCwCard,
                            title: Text(n.title),
                            content: Text(
                              'Full story would open here.\n\n${n.time}\n\n(Demo notification)',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Close'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.pushNamed('news');
                                },
                                child: const Text('Go to News'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
