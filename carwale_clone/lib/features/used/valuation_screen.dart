import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../widgets/cw_page_scaffold.dart';

class ValuationScreen extends StatefulWidget {
  const ValuationScreen({super.key});

  @override
  State<ValuationScreen> createState() => _ValuationScreenState();
}

class _ValuationScreenState extends State<ValuationScreen> {
  final _make = TextEditingController(text: 'Maruti Suzuki');
  final _model = TextEditingController(text: 'Swift');
  final _year = TextEditingController(text: '2019');

  @override
  void dispose() {
    _make.dispose();
    _model.dispose();
    _year.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CwSubpageScaffold(
      title: 'Used car valuation',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Fair market value based on make, model, year & condition (indicative demo).',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.45),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _make,
            decoration: const InputDecoration(labelText: 'Make', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _model,
            decoration: const InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _year,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kCwTeal, minimumSize: const Size.fromHeight(48)),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: kCwCard,
                  title: const Text('Estimated range'),
                  content: const Text(
                    '₹ 4.8 Lakh – ₹ 5.4 Lakh\n\nBased on similar listings in your city. Actual offer may vary after inspection.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                  ],
                ),
              );
            },
            child: const Text('Calculate value', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
