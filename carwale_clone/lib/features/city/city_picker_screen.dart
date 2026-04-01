import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class CityPickerScreen extends ConsumerWidget {
  const CityPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);
    final current = ref.watch(selectedCityProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) => CwSubpageScaffold(
        title: 'Select city',
        body: ListView.builder(
          itemCount: catalog.cities.length,
          itemBuilder: (context, i) {
            final c = catalog.cities[i];
            final sel = c == current;
            return ListTile(
              title: Text(c),
              trailing: sel ? const Icon(Icons.check, color: kCwTeal) : null,
              selected: sel,
              onTap: () async {
                await ref.read(selectedCityProvider.notifier).setCity(c);
                if (context.mounted) context.pop();
              },
            );
          },
        ),
      ),
    );
  }
}
