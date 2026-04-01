import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../widgets/cw_page_scaffold.dart';

class LoanOffersScreen extends StatelessWidget {
  const LoanOffersScreen({super.key});

  static const _banks = [
    ('HDFC Bank', '8.5% – 10.2% p.a. · up to 7 years'),
    ('ICICI Bank', '8.7% – 10.5% p.a. · quick approval'),
    ('Axis Bank', '8.9% – 11% p.a. · pre-approved offers'),
    ('SBI', '8.4% – 9.8% p.a. · PSU rates'),
    ('Kotak Mahindra', '9% – 11.2% p.a. · digital journey'),
  ];

  @override
  Widget build(BuildContext context) {
    return CwSubpageScaffold(
      title: 'Car loan partners',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Compare indicative rates (demo). Actual offers depend on credit profile and car model.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.45),
          ),
          const SizedBox(height: 20),
          ..._banks.map(
            (b) => Card(
              color: kCwCard,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(b.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(b.$2, style: const TextStyle(color: kCwMuted)),
                trailing: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Would open ${b.$1} application (demo).')),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
