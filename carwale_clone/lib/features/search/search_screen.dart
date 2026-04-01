import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final q = widget.initialQuery;
    if (q != null && q.isNotEmpty) {
      _controller.text = q;
    }
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final q = widget.initialQuery;
    if (q != null && q.isNotEmpty && q != oldWidget.initialQuery) {
      _controller.text = q;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_SearchRow> _results(String q, CarWaleCatalog c) {
    final ql = q.toLowerCase();
    final qCompact = ql.replaceAll(RegExp(r'\s+'), '');
    final seen = <String>{};
    final rows = <_SearchRow>[];
    for (final car in c.cars) {
      final hay = '${car.fullName} ${car.brand} ${car.name}'.toLowerCase();
      final hayC = hay.replaceAll(RegExp(r'\s+'), '');
      if (hay.contains(ql) || (qCompact.length >= 2 && hayC.contains(qCompact))) {
        if (seen.add(car.id)) rows.add(_SearchRow.car(car));
      }
    }
    if (ql.contains('land') || ql.contains('cruis')) {
      for (final label in c.searchCompareLabels) {
        rows.add(_SearchRow.compare(label));
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);
    final q = _controller.text.trim();

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        return Scaffold(
          key: const Key('screen_search'),
          backgroundColor: kCwBg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 8, 8),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: () => context.pop()),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: kCwCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: q.isEmpty ? kCwSearchFocus.withValues(alpha: 0.85) : kCwSearchFocus,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  autofocus: true,
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                  cursorColor: kCwTeal,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '',
                                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              if (q.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() {});
                                  },
                                ),
                              if (q.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: q.isEmpty
                      ? _EmptySearchBody(catalog: catalog)
                      : _ResultsBody(
                          rows: _results(q, catalog),
                          query: q,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SearchRow {
  _SearchRow._(this.car, this.compareLabel);
  factory _SearchRow.car(Car c) => _SearchRow._(c, null);
  factory _SearchRow.compare(String label) => _SearchRow._(null, label);

  final Car? car;
  final String? compareLabel;
}

class _EmptySearchBody extends StatelessWidget {
  const _EmptySearchBody({required this.catalog});

  final CarWaleCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
          child: Text(
            'Recently Viewed',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        ...catalog.recentCarIds.map((id) {
          final c = catalog.carById(id);
          if (c == null) return const SizedBox.shrink();
          return _SearchListTile(
            icon: Icons.schedule,
            title: c.fullName,
            onTap: () => context.pushNamed('car', pathParameters: {'id': c.id}),
          );
        }),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            'Recommended For You',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: ['celerio', 'baleno'].map((id) {
              final c = catalog.carById(id);
              if (c == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => context.pushNamed('car', pathParameters: {'id': c.id}),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: kCwCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kCwBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            color: const Color(0xFF2A2A2A),
                            padding: const EdgeInsets.all(8),
                            child: Image.network(c.imageUrls.first, fit: BoxFit.contain),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.fullName, style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 6),
                              Text(
                                c.priceRange,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'All prices shown above are On-Road Prices in Hyderabad.',
            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.45), height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Trending',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        ...catalog.trending.map(
          (t) => _SearchListTile(
            icon: Icons.trending_up,
            title: t,
            onTap: () {
              final tl = t.toLowerCase();
              Car? hit;
              for (final c in catalog.cars) {
                if (tl.contains(c.name.toLowerCase()) || c.fullName.toLowerCase().contains(tl)) {
                  hit = c;
                  break;
                }
              }
              if (hit != null) {
                context.pushNamed('car', pathParameters: {'id': hit.id});
              } else {
                context.pushNamed('search', queryParameters: {'q': t});
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SearchListTile extends StatelessWidget {
  const _SearchListTile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kCwBorder))),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
          ],
        ),
      ),
    );
  }
}

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({required this.rows, required this.query});

  final List<_SearchRow> rows;
  final String query;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Center(
        child: Text('No results for "$query"', style: const TextStyle(color: kCwMuted)),
      );
    }
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text('Search Results', style: TextStyle(color: kCwMuted, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
        ...rows.map((r) {
          if (r.compareLabel != null) {
            return _SearchListTile(
              icon: Icons.search,
              title: r.compareLabel!,
              onTap: () => context.pushNamed('compare-result', queryParameters: {'left': 'landcruiser', 'right': 'creta'}),
            );
          }
          final c = r.car!;
          return InkWell(
            onTap: () => context.pushNamed('car', pathParameters: {'id': c.id}),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kCwBorder))),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 20, color: Colors.white70),
                  const SizedBox(width: 12),
                  Expanded(child: Text(c.fullName, style: const TextStyle(fontSize: 15))),
                  if (c.status == 'coming')
                    const Text('Coming soon', style: TextStyle(color: kCwTeal, fontSize: 12)),
                  if (c.status == 'discontinued')
                    const Text('Discontinued', style: TextStyle(color: kCwMuted, fontSize: 12)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
