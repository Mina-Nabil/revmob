import 'dart:collection';

import 'brand.dart';
import 'car.dart';
import 'car_list.dart';
import 'model.dart';
import 'model_color.dart';
import '../offer_defaults.dart';

class Catalog {
  CarList _carList = new CarList();
  HashSet<Brand> _brands = new HashSet<Brand>();
  HashSet<CarModel> _models = new HashSet<CarModel>();
  HashMap<Car, List<ModelColor>> _carColors = new HashMap<Car, List<ModelColor>>();
  HashMap<Car, OfferDefaults> _carOfferInfo = new HashMap<Car, OfferDefaults>();

  //data getters
  List<int> get brandIDs {
    HashSet<int> ret = new HashSet<int>();
    _carList.cars.forEach((car) => ret.add(car.model.brand.id));
    return ret.toList();
  }

  List<Brand> get brands {
    HashSet<Brand> ret = new HashSet<Brand>();
    _carList.cars.forEach((car) => ret.add(car.model.brand));
    return ret.toList();
  }

  List<int> get modelIDs {
    HashSet<int> ret = new HashSet<int>();
    _carList.cars.forEach((car) => ret.add(car.model.id));
    return ret.toList();
  }

  List<CarModel> get models {
    HashSet<CarModel> ret = new HashSet<CarModel>();
    _carList.cars.forEach((car) => ret.add(car.model));
    return ret.toList();
  }

  List<int> get carIDs => _carList.cars.map((e) => e.id).toList();

  CarList get fullCarList => _carList;

  HashSet<Car> get fullListOfCars => _carList.cars;

  int get length => _carList.length;

  bool get isEmpty => length == 0;

  OfferDefaults? getOfferInfo(Car c) {
    if (this.hasCar(c)) {
      return _carOfferInfo[c] ?? null;
    }
  }

  int colorsCount(Car car) => _carColors[car]?.length ?? 0;

  List<ModelColor> getCarColors(Car c) => (_carColors[c] != null) ? _carColors[c]! : [];

  HashSet<ModelColor> get allColors {
    HashSet<ModelColor> all = new HashSet<ModelColor>();
    _carColors.forEach((car, colors) {
      all.addAll(colors);
    });
    return all;
  }

  bool canSubmitColors() {
    bool ret = true;
    fullListOfCars.forEach((c) {
      ret &= colorsCount(c) > 0;
    });
    return ret;
  }

  double get minCarPrice {
    double minPrice = double.maxFinite;
    _carList.cars.forEach((car) {
      if (car.avgPrice < minPrice) minPrice = car.avgPrice;
    });
    return minPrice;
  }

  double get maxCarPrice {
    double maxPrice = double.minPositive;
    _carList.cars.forEach((car) {
      if (car.avgPrice > maxPrice) maxPrice = car.avgPrice;
    });
    return maxPrice;
  }

  //catalog functions
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
    _carList.clear();
    _carColors.clear();
    _carOfferInfo.clear();
  }

  Catalog filterCatalog(
      {String? searchText,
      HashSet<Brand>? brands,
      HashSet<CarModel>? models,
      HashSet<ModelColor>? colors,
      HashSet<Car>? cars,
      double? minPrice,
      double? maxPrice}) {
    Catalog tmp = new Catalog();
    tmp.addCars(filterCars(
        searchText: searchText,
        brands: brands,
        models: models,
        colors: colors,
        cars: cars,
        minPrice: minPrice,
        maxPrice: maxPrice));
    return tmp;
  }

  HashSet<Car> filterCars(
      {String? searchText,
      HashSet<Brand>? brands,
      HashSet<CarModel>? models,
      HashSet<ModelColor>? colors,
      HashSet<Car>? cars,
      double? minPrice,
      double? maxPrice}) {
    HashSet<Car> filtered = new HashSet<Car>();
    _carList.cars.forEach((car) {
      if ((brands == null || (brands.isEmpty || brands.contains(car.model.brand))) &&
          (models == null || (models.isEmpty || models.contains(car.model))) &&
          (colors == null || (colors.isEmpty || this.hasAnyOfColors(car, colors))) &&
          ((minPrice == null) || car.avgPrice >= minPrice) &&
          ((maxPrice == null) || car.avgPrice <= maxPrice) &&
          ((searchText == null) || car.hasText(searchText)) &&
          (cars == null || (cars.isEmpty || cars.contains(car)))) {
        filtered.add(car);
      }
    });
    return filtered;
  }

  HashSet<ModelColor> filterColors({HashSet<Brand>? brandSet, HashSet<CarModel>? modelSet, HashSet<Car>? carSet}) {
    HashSet<Car> filteredCars = filterCars(brands: brandSet, models: modelSet, cars: carSet);
    HashSet<ModelColor> filteredColors = new HashSet<ModelColor>();
    filteredCars.forEach((car) {
      filteredColors.addAll(getCarColors(car));
    });
    if (carSet != null)
      carSet.forEach((car) {
        filteredColors.addAll(getCarColors(car));
      });
    return filteredColors;
  }

  HashSet<Brand> filterBrands(
      {List<Brand> brands = const [],
      List<Car> cars = const [],
      List<CarModel> models = const [],
      List<ModelColor> colors = const []}) {
    HashSet<Brand> filtered = new HashSet<Brand>();
    this._carList.cars.forEach((car) {
      if ((cars.isEmpty || cars.contains(car)) &&
          (brands.isEmpty || brands.contains(car.model.brand)) &&
          (models.isEmpty || models.contains(car.model)) &&
          (colors.isEmpty || this.hasAnyOfColors(car, colors))) {
        filtered.add(car.model.brand);
      }
    });
    return filtered;
  }

  HashSet<CarModel> filterModels(
      {List<Car> brands = const [],
      List<Car> cars = const [],
      List<CarModel> models = const [],
      List<ModelColor> colors = const []}) {
    HashSet<CarModel> filtered = new HashSet<CarModel>();
    this._carList.cars.forEach((car) {
      if ((cars.isEmpty || cars.contains(car)) &&
          (brands.isEmpty || brands.contains(car.model.brand)) &&
          (models.isEmpty || models.contains(car.model)) &&
          (colors.isEmpty || this.hasAnyOfColors(car, colors))) {
        filtered.add(car.model);
      }
    });
    return filtered;
  }

  search(String text) {}

  //catalog CRUD
  bool addCar(Car c) {
    _carList.add(c);
    _models.add(c.model);
    _brands.add(c.model.brand);
    _carColors[c] = [];
    return true;
  }

  bool addCars(Iterable<Car> carlist) {
    bool ret = true;
    carlist.forEach((car) {
      ret &= this.addCar(car);
    });
    return ret;
  }

  bool addCarWithColors(Car c, List<ModelColor> colors) {
    addCar(c);
    _carColors[c] = colors;
    return true;
  }

  bool addColorToCar(Car c, ModelColor color) {
    if (_carList.contains(c)) {
      if (!_carColors.containsKey(c)) _carColors[c] = [];
      _carColors[c]!.add(color);
      return true;
    } else
      return false;
  }

  bool hasCarColor(Car car, ModelColor color) {
    if (_carList.contains(car) && _carColors.containsKey(car)) {
      return _carColors[car]!.contains(color);
    } else
      return false;
  }

  bool hasAnyOfColors(Car car, Iterable<ModelColor> colors) {
    bool ret = false;
    if (_carColors[car] != null)
      for (ModelColor color in colors) {
        if (_carColors[car]!.contains(color)) {
          ret = true;
          break;
        }
      }
    return ret;
  }

  bool hasCar(Car c) => _carList.contains(c);

  bool removeCar(Car c) {
    if (_carList.contains(c)) {
      _carList.removeCar(c);
      _carColors.remove(c);
      if (!_carList.hasModel(c.model)) {
        _models.remove(c.model);
      }
      if (!_carList.hasBrand(c.model.brand)) {
        _brands.remove(c.model.brand);
      }
    }
    return true;
  }

  bool removeCarColor(Car car, ModelColor color) {
    if (hasCarColor(car, color)) {
      _carColors[car]!.remove(color);
      return true;
    }
    return false;
  }

  bool setOfferDefaults(Car car, OfferDefaults offerDefaults) {
    if (this.hasCar(car)) {
      _carOfferInfo[car] = offerDefaults;
      return true;
    } else
      return false;
  }

  operator [](int i) => _carList[i];

  @override
  String toString() {
    String ret = "[";
    fullListOfCars.forEach((element) {
      ret += element.carName + " - " + ((_carColors[element] != null) ? _carColors[element].toString() : "");
    });
    ret += "]";
    return ret;
  }
}
