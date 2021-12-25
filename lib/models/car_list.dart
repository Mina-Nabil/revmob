import 'package:revmo/models/car.dart';

class CarList {
  final List<Car> _cars = [];

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

  operator [](int i) => _cars[i];

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

  @override
  int get hashCode => super.hashCode;
  int get length => _cars.length;

  List<Car> get cars => _cars;

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
