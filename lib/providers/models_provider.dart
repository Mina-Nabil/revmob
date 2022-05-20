import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/cars/model.dart';
import 'package:revmo/services/models_service.dart';
import 'package:revmo/shared/theme.dart';

class ModelsProvider extends ChangeNotifier {
  BuildContext _context;
  ModelsProvider(this._context);

  List<CarModel> _modelsByBrand = [];

  List<CarModel> get brandModels => _modelsByBrand;

  loadModels(int brandID, bool loadCars) async {
    print("calling models");
    ApiResponse<List<CarModel>?> response = await ModelsService.getModels(_context, brandID, loadCars);
    if (response.status == true) {
      _modelsByBrand.clear();
      _modelsByBrand = response.body!;
      _modelsByBrand.forEach((e) => print(e));
      notifyListeners();
    } else {
      RevmoTheme.showRevmoSnackbar(_context, response.msg);
    }
  }
}
