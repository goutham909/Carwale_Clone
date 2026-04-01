import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/models/catalog_models.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        NewsArticle? article;
        for (final n in catalog.news) {
          if (n.id == articleId) {
            article = n;
            break;
          }
        }
        if (article == null) {
          return const CwSubpageScaffold(title: 'Article', body: Center(child: Text('Not found')));
        }
        return CwSubpageScaffold(
          title: 'News',
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(article.imageUrl, height: 220, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.25)),
                      const SizedBox(height: 12),
                      Text('${article.author} · ${article.time} · ${article.views}', style: const TextStyle(color: kCwMuted)),
                      const SizedBox(height: 20),
                      Text(
                        'This is placeholder body copy for a demo clone. On the real CarWale app you would read the full story, '
                        'see image galleries, embedded videos, and related cars.\n\n'
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.',
                        style: TextStyle(height: 1.55, color: Colors.white.withValues(alpha: 0.88)),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Shared article link (demo).')),
                          );
                        },
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                      ),
                    ],
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
