import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/catalog.dart';
import 'package:revmo/services/catalog_service.dart';

class CatalogProvider extends ChangeNotifier {
  BuildContext _context;
  CatalogProvider(this._context);
  CatalogService _catalogService = new CatalogService();

  Catalog _sellerCatalog = new Catalog();
  Catalog get catalog => _sellerCatalog;

  loadCatalog({bool forceLoad = false}) async {
    if (forceLoad || _sellerCatalog.isEmpty) {
      ApiResponse<Catalog?> response = await _catalogService.getSellerCatalog(_context);
      if (response.status && response.body !=null) 
      _sellerCatalog.clone(response.body!);
      print("loaded catalog is " + _sellerCatalog.toString());
    }
    notifyListeners();
  }
}
