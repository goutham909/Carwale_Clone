import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class EmiCalculatorScreen extends ConsumerStatefulWidget {
  const EmiCalculatorScreen({super.key, this.initialCarId});

  final String? initialCarId;

  @override
  ConsumerState<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends ConsumerState<EmiCalculatorScreen> {
  late double _principalLakh;
  double _tenureYears = 5;
  double _rateAnnual = 9.5;
  bool _initialCarApplied = false;

  @override
  void initState() {
    super.initState();
    _principalLakh = 8;
  }

  void _applyCar(Car? car) {
    if (car == null) return;
    final match = RegExp(r'([\d.]+)').firstMatch(car.priceRange.replaceAll(',', ''));
    if (match != null) {
      final v = double.tryParse(match.group(1)!);
      if (v != null && v < 200) _principalLakh = v;
    }
  }

  double get _emi {
    final p = _principalLakh * 100000;
    final n = (_tenureYears * 12).round();
    if (n <= 0) return 0;
    final r = _rateAnnual / 12 / 100;
    if (r == 0) return p / n;
    final pow = math.pow(1 + r, n).toDouble();
    return p * r * pow / (pow - 1);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final car = widget.initialCarId != null ? catalog.carById(widget.initialCarId!) : null;
        if (car != null && !_initialCarApplied) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _initialCarApplied) return;
            _initialCarApplied = true;
            setState(() => _applyCar(car));
          });
        }
        return CwSubpageScaffold(
          title: 'EMI calculator',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (car != null)
                Card(
                  color: kCwCard,
                  child: ListTile(
                    title: Text(car.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Prefilled from on-road estimate', style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
                    trailing: TextButton(
                      onPressed: () => setState(() => _applyCar(car)),
                      child: const Text('Apply'),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Loan amount (₹ Lakh)', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
              Slider(
                value: _principalLakh.clamp(1, 50),
                min: 1,
                max: 50,
                divisions: 49,
                label: '${_principalLakh.toStringAsFixed(1)} L',
                onChanged: (v) => setState(() => _principalLakh = v),
              ),
              Text('${_principalLakh.toStringAsFixed(1)} Lakh', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 20),
              Text('Tenure (years)', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
              Slider(
                value: _tenureYears,
                min: 1,
                max: 8,
                divisions: 7,
                label: '${_tenureYears.round()} y',
                onChanged: (v) => setState(() => _tenureYears = v),
              ),
              const SizedBox(height: 20),
              Text('Interest rate (% p.a.)', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
              Slider(
                value: _rateAnnual,
                min: 7,
                max: 15,
                divisions: 80,
                label: '${_rateAnnual.toStringAsFixed(1)}%',
                onChanged: (v) => setState(() => _rateAnnual = v),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kCwCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kCwBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estimated EMI', style: TextStyle(color: kCwMuted)),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${_emi.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}/month',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kCwTeal),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Indicative only. Final EMI depends on bank, profile, and schemes.',
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.45), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kCwCoralCta, minimumSize: const Size.fromHeight(48)),
                onPressed: () => context.pushNamed('loan-offers'),
                child: const Text('Get loan offers from partners', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        );
      },
    );
  }
}
