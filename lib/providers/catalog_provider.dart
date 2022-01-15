import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/catalog.dart';
import 'package:revmo/models/cars/model.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/services/catalog_service.dart';

class CatalogProvider extends ChangeNotifier {
  BuildContext _context;
  CatalogProvider(this._context);
  CatalogService _catalogService = new CatalogService();

  Catalog _sellerCatalog = new Catalog();
  Catalog _filteredCatalog = new Catalog();

  Catalog get catalog => _sellerCatalog;
  Catalog get filteredCatalog => _filteredCatalog;

  loadCatalog({bool forceLoad = false}) async {
    if (forceLoad || _sellerCatalog.isEmpty) {
      ApiResponse<Catalog?> response = await _catalogService.getSellerCatalog(_context);
      if (response.status && response.body != null) {
        _sellerCatalog = response.body!;
        _filteredCatalog = response.body!;
      }
      print("loaded catalog is " + _sellerCatalog.toString());
    }
    notifyListeners();
  }

  addCarsToCatalog(Catalog catalog) async {
    ApiResponse<Catalog?> response = await _catalogService.addToSellerCatalog(_context, catalog);
    if (response.status && response.body != null) {
      _sellerCatalog = response.body!;
      _filteredCatalog = response.body!;
    }
    notifyListeners();
  }

  Future<bool> removeCar(Car car) async {
    ApiResponse<bool?> response = await _catalogService.removeCar(_context, car);
    if (response.status && response.body != null && response.body == true) {
      _sellerCatalog.removeCar(car);
      _filteredCatalog.removeCar(car);
      notifyListeners();
      return true;
    }
    return false;
  }

  filterCatalog(
      {String? search,
      HashSet<Brand>? brands,
      HashSet<ModelColor>? colors,
      HashSet<CarModel>? models,
      HashSet<Car>? catgs,
      double? minPrice,
      double? maxPrice}) {
    _filteredCatalog = _sellerCatalog.filterCatalog(
        searchText: search, brands: brands, colors: colors, models: models, cars: catgs, minPrice: minPrice, maxPrice: maxPrice);
    notifyListeners();
  }
}
