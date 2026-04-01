import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../widgets/cw_page_scaffold.dart';

class SellCarScreen extends StatefulWidget {
  const SellCarScreen({super.key});

  @override
  State<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  final _make = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _km = TextEditingController();

  @override
  void dispose() {
    _make.dispose();
    _model.dispose();
    _year.dispose();
    _km.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CwSubpageScaffold(
      title: 'Sell your car',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'List your car, get inspection & connect with buyers (demo form).',
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
          const SizedBox(height: 12),
          TextField(
            controller: _km,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Kilometers driven', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kCwCoralCta, minimumSize: const Size.fromHeight(48)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing draft saved (demo). Our team would call you on the real app.')),
              );
            },
            child: const Text('Get best price', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.push('/valuation'),
            child: const Text('Instant valuation instead'),
          ),
        ],
      ),
    );
  }
}
