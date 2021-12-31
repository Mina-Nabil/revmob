import 'dart:collection';

import 'package:revmo/models/brand.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/models/car_list.dart';
import 'package:revmo/models/model.dart';
import 'package:revmo/models/model_color.dart';
import 'package:revmo/models/offer_defaults.dart';

class Catalog {
  HashMap<CarModel, CarList> _carsToModelsMap = new HashMap<CarModel, CarList>();
  HashMap<Car, List<ModelColor>> _carColors = new HashMap<Car, List<ModelColor>>();
  HashMap<Car, OfferDefaults> _carOfferInfo = new HashMap<Car, OfferDefaults>();

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

  clone(Catalog c) {
    print("wna ba clone" + c.toString());
    this.clear();
    c.fullListOfCars.forEach((carElement) {
      this.addCar(carElement);
      c.getCarColors(carElement).forEach((colorElement) {
        this.addColorToCar(carElement, colorElement);
      });
      if (c.getOfferInfo(carElement) != null) this.setOfferDefaults(carElement, c.getOfferInfo(carElement)!);
    });
  }

  clear() {
    _carsToModelsMap.clear();
    _carColors.clear();
    _carOfferInfo.clear();
  }

  bool addCar(Car c) {
    if (!_carsToModelsMap.containsKey(c.model)) {
      _carsToModelsMap[c.model] = new CarList();
    }
    _carsToModelsMap[c.model]!.add(c);
    _carColors[c] = [];
    return true;
  }

  bool addCarWithColors(Car c, List<ModelColor> colors) {
    if (!_carsToModelsMap.containsKey(c.model.id)) {
      _carsToModelsMap[c.model] = new CarList();
    }
    _carsToModelsMap[c.model]!.add(c);
    _carColors[c] = colors;
    return true;
  }

  bool addColorToCar(Car c, ModelColor color) {
    if (_carsToModelsMap.containsKey(c.model.id) && _carsToModelsMap[c.model]!.hasCar(c)) {
      if (!_carColors.containsKey(c)) _carColors[c] = [];
      _carColors[c]!.add(color);
      return true;
    } else
      return false;
  }

  bool hasCarColor(Car car, ModelColor color) {
    if (_carsToModelsMap.containsKey(car.model) && _carsToModelsMap[car.model]!.hasCar(car) && _carColors.containsKey(car)) {
      return _carColors[car]!.contains(color);
    } else
      return false;
  }

  List<ModelColor> getCarColors(Car c) => (_carColors[c] != null) ? _carColors[c]! : [];

  bool hasCar(Car c) {
    print("geet hna");
    if (_carsToModelsMap.containsKey(c.model)) {
      return _carsToModelsMap[c.model]!.hasCar(c);
    } else
      return false;
  }

  bool removeCar(Car c) {
    if (_carsToModelsMap.containsKey(c.model)) {
      _carsToModelsMap[c.model]!.removeCar(c);
      _carColors.remove(c);
    }
    return true;
  }

  CarList get fullCarList {
    CarList ret = new CarList();
    _carsToModelsMap.forEach((model, carlist) {
      ret.addCarList(carlist);
    });
    return ret;
  }

  List<Car> get fullListOfCars {
    List<Car> ret = [];
    _carsToModelsMap.forEach((model, carlist) {
      ret.addAll(carlist.cars);
    });
    return ret;
  }

  int get length {
    int ret = 0;
    _carsToModelsMap.forEach((model, carlist) {
      ret += carlist.length;
    });
    return ret;
  }

  bool get isEmpty => length == 0;

  OfferDefaults? getOfferInfo(Car c) {
    if (this.hasCar(c)) {
      return _carOfferInfo[c] ?? null;
    }
  }

  bool setOfferDefaults(Car car, OfferDefaults offerDefaults) {
    if (this.hasCar(car)) {
      _carOfferInfo[car] = offerDefaults;
      return true;
    } else
      return false;
  }

  @override
  String toString() {
    String ret = "[";
    fullListOfCars.forEach((element) {
      ret += element.carName + " - ";
    });
    ret += "]";
    return ret;
  }
}
