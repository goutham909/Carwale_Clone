import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class NewCarFilterScreen extends ConsumerWidget {
  const NewCarFilterScreen({super.key, required this.filterType});

  /// budget | body | fuel
  final String filterType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final title = switch (filterType) {
          'body' => 'Body type',
          'fuel' => 'Fuel type',
          _ => 'Budget',
        };

        return CwSubpageScaffold(
          title: title,
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._optionsFor(filterType).map(
                (opt) => Card(
                  color: kCwCard,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(opt.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(opt.subtitle),
                    trailing: const Icon(Icons.chevron_right, color: kCwMuted),
                    onTap: () {
                      final filtered = _applyFilter(catalog.cars, filterType, opt.key);
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => _FilterResultsPage(title: opt.label, cars: filtered),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static List<_Opt> _optionsFor(String type) {
    switch (type) {
      case 'body':
        return const [
          _Opt('hatch', 'Hatchback', 'Compact city cars'),
          _Opt('suv', 'SUV', 'High seating, road presence'),
          _Opt('sedan', 'Sedan', 'Comfort & boot space'),
        ];
      case 'fuel':
        return const [
          _Opt('petrol', 'Petrol', 'Widest availability'),
          _Opt('diesel', 'Diesel', 'Highway torque'),
          _Opt('ev', 'Electric', 'Zero tailpipe emissions'),
        ];
      default:
        return const [
          _Opt('u5', 'Under ₹ 5 Lakh', 'Entry segment'),
          _Opt('5-10', '₹ 5 – 10 Lakh', 'Mass market'),
          _Opt('10-20', '₹ 10 – 20 Lakh', 'Mid SUVs & sedans'),
          _Opt('20p', '₹ 20 Lakh+', 'Premium'),
        ];
    }
  }

  static List<Car> _applyFilter(List<Car> cars, String type, String key) {
    if (type == 'budget') {
      return cars.where((c) {
        final low = _lowestLakh(c);
        if (low == null) return false;
        switch (key) {
          case 'u5':
            return low < 5;
          case '5-10':
            return low >= 5 && low < 10;
          case '10-20':
            return low >= 10 && low < 20;
          case '20p':
            return low >= 20;
          default:
            return true;
        }
      }).toList();
    }
    if (type == 'body') {
      return cars.where((c) {
        final n = '${c.name} ${c.brand}'.toLowerCase();
        switch (key) {
          case 'suv':
            return n.contains('suv') || n.contains('creta') || n.contains('seltos') || n.contains('punch') || n.contains('nexon') || n.contains('hyryder') || n.contains('exter') || n.contains('fronx') || n.contains('cruiser');
          case 'sedan':
            return n.contains('dzire') || n.contains('verna') || n.contains('city') || n.contains('slavia');
          case 'hatch':
          default:
            return n.contains('ritz') || n.contains('celerio') || n.contains('baleno') || n.contains('swift') || n.contains('i20');
        }
      }).toList();
    }
    if (type == 'fuel') {
      return cars.where((c) {
        final v = c.version.toLowerCase();
        final n = c.name.toLowerCase();
        switch (key) {
          case 'diesel':
            return v.contains('diesel');
          case 'ev':
            return v.contains('ev') || n.contains('ev') || v.contains('electric');
          case 'petrol':
          default:
            return v.contains('petrol') || (!v.contains('diesel') && !v.contains('electric') && !v.contains('hybrid'));
        }
      }).toList();
    }
    return cars;
  }

  static double? _lowestLakh(Car c) {
    final m = RegExp(r'Rs\.\s*([\d.]+)|₹\s*([\d.]+)|([\d.]+)\s*Lakh', caseSensitive: false).firstMatch(c.priceRange);
    if (m == null) return null;
    final s = m.group(1) ?? m.group(2) ?? m.group(3);
    return double.tryParse(s ?? '');
  }
}

class _Opt {
  const _Opt(this.key, this.label, this.subtitle);

  final String key;
  final String label;
  final String subtitle;
}

class _FilterResultsPage extends StatelessWidget {
  const _FilterResultsPage({required this.title, required this.cars});

  final String title;
  final List<Car> cars;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCwBg,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: cars.isEmpty
          ? const Center(child: Text('No cars match (demo heuristics). Try another filter.', textAlign: TextAlign.center))
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: cars.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final c = cars[i];
                return Material(
                  color: kCwCard,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: SizedBox(
                      width: 72,
                      child: Image.network(c.imageUrls.first, fit: BoxFit.contain),
                    ),
                    title: Text(c.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(c.priceRange, style: const TextStyle(color: kCwMuted)),
                    trailing: const Icon(Icons.chevron_right, color: kCwMuted),
                    onTap: () => context.pushNamed('car', pathParameters: {'id': c.id}),
                  ),
                );
              },
            ),
    );
  }
}
