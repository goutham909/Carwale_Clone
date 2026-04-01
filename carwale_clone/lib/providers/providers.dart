import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/catalog_models.dart';
import '../data/repositories/catalog_repository.dart';
import '../data/sources/mock_catalog_source.dart';

export 'user_prefs_providers.dart';

final mockCatalogSourceProvider = Provider<MockCatalogSource>((ref) {
  return MockCatalogSource();
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(ref.watch(mockCatalogSourceProvider));
});

final catalogProvider = FutureProvider<CarWaleCatalog>((ref) async {
  return ref.watch(catalogRepositoryProvider).getCatalog();
});
