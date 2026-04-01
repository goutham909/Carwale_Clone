import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  int _topTab = 0; // 0 news, 1 media
  String _chip = 'all'; // all | reviews | reports

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final articles = _topTab == 0
            ? catalog.news.where((n) {
                if (_chip == 'all') return true;
                return n.category == _chip;
              }).toList()
            : <NewsArticle>[];

        return Scaffold(
          key: const Key('screen_news'),
          backgroundColor: kCwBg,
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
            title: const Text('News', style: TextStyle(fontWeight: FontWeight.w700)),
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TopTab(
                      label: 'NEWS & REVIEWS',
                      selected: _topTab == 0,
                      onTap: () => setState(() => _topTab = 0),
                    ),
                  ),
                  Expanded(
                    child: _TopTab(
                      label: 'IMAGES & VIDEOS',
                      selected: _topTab == 1,
                      onTap: () => setState(() => _topTab = 1),
                    ),
                  ),
                ],
              ),
              if (_topTab == 0)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                  child: Row(
                    children: [
                      _Chip(label: 'All', selected: _chip == 'all', onTap: () => setState(() => _chip = 'all')),
                      const SizedBox(width: 10),
                      _Chip(label: 'Reviews', selected: _chip == 'reviews', onTap: () => setState(() => _chip = 'reviews')),
                      const SizedBox(width: 10),
                      _Chip(label: 'Special Reports', selected: _chip == 'reports', onTap: () => setState(() => _chip = 'reports')),
                    ],
                  ),
                ),
              Expanded(
                child: _topTab == 1
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Images & Videos (demo).\n\nSwitch to NEWS & REVIEWS for articles.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), height: 1.5),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: articles.length,
                        itemBuilder: (context, i) => _NewsCard(article: articles[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: selected ? kCwTeal : Colors.transparent, width: 3.5),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 0.5,
            color: selected ? kCwTeal : kCwMuted,
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? kCwTeal : Colors.white,
        side: BorderSide(color: selected ? kCwTeal : Colors.white54),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      decoration: BoxDecoration(
        color: kCwCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kCwBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: Stack(
              children: [
                Image.network(article.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Text(
                    'carwale',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: kCwNewsBlue,
                    child: const Text('NEWS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.favorite_border, size: 18),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Text(article.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, height: 1.35)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(article.author, style: const TextStyle(color: kCwMuted, fontSize: 12)),
                Text(article.time, style: const TextStyle(color: kCwMuted, fontSize: 12)),
              ],
            ),
          ),
          const Divider(color: kCwBorder, height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined, size: 16, color: Colors.white.withValues(alpha: 0.5)),
                const SizedBox(width: 6),
                Text(article.views, style: const TextStyle(color: kCwMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
