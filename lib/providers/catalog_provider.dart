import 'package:flutter/material.dart';
import 'package:revmo/models/car_list.dart';
import 'package:revmo/models/catalog.dart';

class CatalogProvider extends ChangeNotifier {
  BuildContext _context;
  CatalogProvider(this._context);

  Catalog _sellerCatalog = new Catalog();
  Catalog get catalog => _sellerCatalog;

  loadCatalog(){
    
  }
}
