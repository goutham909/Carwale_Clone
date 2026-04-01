import 'package:flutter/services.dart' show rootBundle;

import '../models/catalog_models.dart';

class MockCatalogSource {
  Future<CarWaleCatalog> loadCatalog() async {
    final raw = await rootBundle.loadString('assets/mock/catalog.json');
    return CarWaleCatalog.decode(raw);
  }
}
