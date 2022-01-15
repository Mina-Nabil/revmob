import 'dart:collection';

import 'package:revmo/models/brand.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/models/model.dart';

class CarList {
  final HashSet<Car> _cars = new HashSet();

  CarList({List<Car>? cars});

  add(Car c) {
    _cars.add(c);
  }

  addCarList(CarList cars) {
    _cars.addAll(cars.cars);
  }

  addListOfCars(List<Car> cars) {
    _cars.addAll(cars);
  }

  removeCar(Car c) {
    _cars.remove(c);
  }

  bool hasCar(Car c) {
    return _cars.contains(c);
  }

  bool hasModel(CarModel model) {
    bool ret = false;
    for (var car in _cars) {
      if (car.model == model) {
        ret = true;
        break;
      }
    }
    return ret;
  }

  bool hasBrand(Brand brand) {
    bool ret = false;
    for (var car in _cars) {
      if (car.model.brand == brand) {
        ret = true;
        break;
      }
    }
    return ret;
  }

  clear() {
    _cars.clear();
  }

  bool contains(Car car) {
    return _cars.contains(car);
  }

  operator [](int i) => _cars.elementAt(i);

  operator ==(otherList) {
    if (!(otherList is CarList)) return false;
    if (otherList.length != this.length) return false;
    for (Car e in _cars) {
      if (!otherList._cars.contains(e)) {
        return false;
      }
    }
    return true;
  }

  operator +(Car c) {
    _cars.add(c);
  }

  @override
  int get hashCode => super.hashCode;
  int get length => _cars.length;

  HashSet<Car> get cars => _cars;

  @override
  String toString() {
    String ret = "[";
    _cars.forEach((element) {
      ret += element.carName + " - ";
    });
    ret += "]";
    return ret;
  }
}
