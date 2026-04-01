import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/cw_page_scaffold.dart';

class GalleryHubScreen extends ConsumerStatefulWidget {
  const GalleryHubScreen({super.key, required this.carId, required this.mode});

  final String carId;
  /// colors | images | videos | interior | exterior
  final String mode;

  @override
  ConsumerState<GalleryHubScreen> createState() => _GalleryHubScreenState();
}

class _GalleryHubScreenState extends ConsumerState<GalleryHubScreen> {
  int _page = 0;
  PageController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.mode) {
      case 'colors':
        return 'Colours';
      case 'videos':
        return 'Videos';
      case 'interior':
        return 'Interior 360°';
      case 'exterior':
        return 'Exterior 360°';
      default:
        return 'Images';
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(catalogProvider);

    return async.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: kCwTeal))),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (catalog) {
        final car = catalog.carById(widget.carId);
        if (car == null) {
          return CwSubpageScaffold(title: _title, body: const Center(child: Text('Car not found')));
        }

        final urls = _urlsForMode(car.imageUrls, widget.mode);
        _page = _page.clamp(0, urls.length - 1);
        _controller ??= PageController(initialPage: _page);

        return CwSubpageScaffold(
          title: _title,
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller!,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: urls.length,
                  itemBuilder: (_, i) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(
                          color: const Color(0xFF0A0A0A),
                          child: Image.network(urls[i], fit: BoxFit.contain),
                        ),
                        if (widget.mode == 'interior' || widget.mode == 'exterior')
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.black54,
                              child: const Text(
                                'Drag to rotate — demo uses stills. A production app streams 360° tiles.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        if (widget.mode == 'videos')
                          const Center(
                            child: Icon(Icons.play_circle_fill, size: 72, color: Colors.white70),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                color: kCwCard,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${_page + 1} / ${urls.length}', style: const TextStyle(color: kCwMuted)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _urlsForMode(List<String> base, String mode) {
    if (mode == 'colors') {
      return [
        ...base,
        if (base.length < 4) ...base.map((u) => '$u&sat=-30'),
        if (base.length < 4) ...base.map((u) => '$u&sat=30'),
      ].take(5).toList();
    }
    if (mode == 'videos') {
      return base.isEmpty ? ['https://images.unsplash.com/photo-1619405399517-d7fce0f13340?w=800'] : base;
    }
    return base.length > 1 ? base : [...base, ...base, ...base];
  }
}
