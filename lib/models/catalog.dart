import 'dart:collection';

import 'package:revmo/models/brand.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/models/car_list.dart';
import 'package:revmo/models/model.dart';

class Catalog {
  HashMap<CarModel, CarList> _carsToModelsMap = new HashMap<CarModel, CarList>();

  List<int> get brandIDs {
    HashSet<int> ret = new HashSet<int>();
    _carsToModelsMap.keys.forEach((model) => ret.add(model.brand.id));
    return ret.toList();
  }

  List<Brand> get brands {
    HashSet<Brand> ret = new HashSet<Brand>();
    _carsToModelsMap.keys.forEach((model) => ret.add(model.brand));
    return ret.toList();
  }

  List<int> get modelIDs => _carsToModelsMap.keys.map((e) => e.id).toList();
  List<CarModel> get models => _carsToModelsMap.keys.toList();

  bool addCar(Car c) {
    if (!_carsToModelsMap.containsKey(c.model.id)) {
      _carsToModelsMap[c.model] = new CarList();
    }
    _carsToModelsMap[c.model]!.add(c);
    return true;
  }

  bool hasCar(Car c) {
    if (_carsToModelsMap.containsKey(c.model)) {
      return _carsToModelsMap[c.model]!.hasCar(c);
    } else
      return false;
  }

  bool removeCar(Car c) {
    if (_carsToModelsMap.containsKey(c.model)) {
      _carsToModelsMap[c.model]!.removeCar(c);
    }
    return true;
  }

  int get length {
    int ret = 0;
    _carsToModelsMap.forEach((model, carlist) {
      ret += carlist.length;
    });
    return ret;
  }
}
