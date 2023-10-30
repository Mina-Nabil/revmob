import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/services/brands_service.dart';
import 'package:revmo/shared/theme.dart';

class BrandsProvider extends ChangeNotifier {
  final BuildContext context;
  BrandsProvider(this.context);

  List<Brand> _brands = [];

  List<Brand> get brands => _brands;

  loadBrands() async {
    ApiResponse<List<Brand>?> response = await BrandsService.getBrands(context);
    if (response.body != null && response.body is List<Brand>) {
      _brands.clear();
      _brands = response.body!;
      print(response.body);
      notifyListeners();
    } else {
      RevmoTheme.showRevmoSnackbar(context, response.msg);
    }
  }
}
