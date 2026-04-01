import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class TestDriveScreen extends ConsumerStatefulWidget {
  const TestDriveScreen({super.key, required this.carId});

  final String carId;

  @override
  ConsumerState<TestDriveScreen> createState() => _TestDriveScreenState();
}

class _TestDriveScreenState extends ConsumerState<TestDriveScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _home = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final car = catalog.carById(widget.carId);
        return CwSubpageScaffold(
          title: 'Book test drive',
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (car != null)
                Text(car.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                'Demo flow — no data is sent. A dealer would contact you on a real app.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Mobile number', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text('Preferred slot', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Home'), icon: Icon(Icons.home_outlined)),
                  ButtonSegment(value: false, label: Text('Showroom'), icon: Icon(Icons.store_mall_directory_outlined)),
                ],
                selected: {_home},
                onSelectionChanged: (s) => setState(() => _home = s.first),
              ),
              const SizedBox(height: 28),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kCwCoralCta, minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test drive request saved (demo).')),
                  );
                },
                child: const Text('Submit request', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        );
      },
    );
  }
}
