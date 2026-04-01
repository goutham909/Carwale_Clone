import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../widgets/cw_page_scaffold.dart';

class RcAssistanceScreen extends StatelessWidget {
  const RcAssistanceScreen({super.key});

  static const _steps = [
    'Seller shares RC, insurance & ID proofs securely.',
    'Buyer pays token; paperwork checklist is generated.',
    'RTO appointment is scheduled; RC transfer forms are prefilled.',
    'Our partner assists with hypothecation removal if needed.',
    'Final handover after RC update confirmation.',
  ];

  @override
  Widget build(BuildContext context) {
    return CwSubpageScaffold(
      title: 'RC transfer help',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Free assistance on verified transactions (demo copy).',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.45),
          ),
          const SizedBox(height: 20),
          ..._steps.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: kCwTeal.withValues(alpha: 0.3),
                        child: Text('${e.key + 1}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(e.value, style: const TextStyle(height: 1.4))),
                    ],
                  ),
                ),
              ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kCwCoralCta, minimumSize: const Size.fromHeight(48)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('An advisor would call you (demo).')),
              );
            },
            child: const Text('Request callback', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
