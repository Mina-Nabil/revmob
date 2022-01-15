import 'brand.dart';
import 'car.dart';
import 'car_list.dart';
import 'car_type.dart';
import 'model_color.dart';
import 'revmo_image.dart';

class CarModel {
  //DB keys
  static const DB_id_KEY = "id";
  static const DB_name_KEY = "MODL_NAME";
  static const DB_imageURL_KEY = "image_url";
  static const DB_type_KEY = "type";
  static const DB_cars_KEY = "cars";
  static const DB_brand_KEY = "brand";
  static const DB_year_KEY = "MODL_YEAR";
  static const DB_colors_KEY = "colors";
  static const DB_model_images_KEY = "images";
  static const DB_model_image_url_KEY = "image_url";
  static const DB_model_image_sort_KEY = "MOIM_SORT";
  static const DB_arbcName_KEY = "MODL_ARBC_NAME";

  final int _id;
  final String _name;
  final String _imageURL;
  final String _year;
  final String _arbcName;
  final Brand _brand;
  final CarType _type;
  final List<String> _colorImages;
  final CarList _cars;
  final List<ModelColor> _colors;
  final List<RevmoCarImage> _images;

  CarModel(
    this._id,
    this._name,
    this._imageURL,
    this._brand,
    this._type,
    this._year,
    this._arbcName,
  )   : _cars = CarList(),
        _colors = [],
        _images = [],
        _colorImages = [];

  CarModel.fromJson(Map<String, dynamic> json, {bool loadCars = false})
      : _id = json[DB_id_KEY],
        _name = json[DB_name_KEY],
        _year = json[DB_year_KEY],
        _arbcName = json[DB_arbcName_KEY],
        _brand = Brand.fromJson(json[DB_brand_KEY]),
        _type = CarType.fromJson(json[DB_type_KEY]),
        _imageURL = json[DB_imageURL_KEY],
        _colorImages = [],
        _colors = [],
        _images = [],
        _cars = CarList() {
    if (json.containsKey(DB_colors_KEY) && json[DB_colors_KEY] is List<dynamic>) {
      json[DB_colors_KEY].forEach((e) {
        _colors.add(ModelColor.fromJson(e));
      });
    }
    if (json.containsKey(DB_model_images_KEY) && json[DB_model_images_KEY] is List<dynamic>) {
      json[DB_model_images_KEY].forEach((e) {
        _images.add(
            RevmoCarImage(imageURL: e[DB_model_image_url_KEY], sortingValue: e[DB_model_image_sort_KEY], isModelImage: true));
      });
    }
    if (loadCars && json.containsKey(DB_cars_KEY) && json[DB_cars_KEY] is List<dynamic>) {
      json[DB_cars_KEY].forEach((e) {
        _cars.add(Car.fromJson(e, model: this));
      });
    }
  }

  int get id => _id;
  String get name => _name;
  String get fullName => brand.name + " " + _name;
  String get imageUrl => _imageURL;
  CarType get type => _type;
  String get year => _year;
  String get arbcName => _arbcName;
  Brand get brand => _brand;
  CarList get cars => _cars;
  List<String> get colorImages => _colorImages;
  List<RevmoCarImage> get images => _images;
  List<ModelColor> get colors => _colors;
  bool get hasCars => _cars.length > 0;

  operator ==(o) => o is CarModel && id == o.id;

  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return this.fullName + " " + cars.length.toString() + " cars";
  }
}
