import '../models/catalog_models.dart';
import '../sources/mock_catalog_source.dart';

class CatalogRepository {
  CatalogRepository(this._source);

  final MockCatalogSource _source;

  Future<CarWaleCatalog> getCatalog() => _source.loadCatalog();
}
