import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  bool _analytics = true;
  bool _personalized = true;

  @override
  Widget build(BuildContext context) {
    return CwSubpageScaffold(
      title: 'Privacy & data',
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Traffic is encrypted in transit on production apps. This clone stores preferences only on device (saved cars, city).',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.45),
            ),
          ),
          SwitchListTile(
            title: const Text('Usage analytics'),
            subtitle: const Text('Help improve the product (demo toggle)'),
            value: _analytics,
            activeThumbColor: kCwTeal,
            onChanged: (v) => setState(() => _analytics = v),
          ),
          SwitchListTile(
            title: const Text('Personalized offers'),
            subtitle: const Text('Match alerts to your interests'),
            value: _personalized,
            activeThumbColor: kCwTeal,
            onChanged: (v) => setState(() => _personalized = v),
          ),
          const Divider(color: kCwBorder),
          ListTile(
            title: const Text('Download my data'),
            trailing: const Icon(Icons.download_outlined),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Would email an export link (demo).')),
              );
            },
          ),
          ListTile(
            title: const Text('Delete account & data'),
            titleTextStyle: const TextStyle(color: kCwCoral),
            trailing: const Icon(Icons.delete_forever_outlined, color: kCwCoral),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: kCwCard,
                  title: const Text('Delete all data?'),
                  content: const Text('This demo will clear saved cars from this device.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Delete', style: TextStyle(color: kCwCoral)),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                await ref.read(savedCarIdsProvider.notifier).clear();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved cars cleared. Other demo data resets on reinstall.')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
