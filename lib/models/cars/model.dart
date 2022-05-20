import 'brand.dart';
import 'car.dart';
import 'car_list.dart';
import 'car_type.dart';
import 'model_color.dart';
import 'revmo_image.dart';

class CarModel {
  //DB keys
  static const API_id_Key = "id";
  static const API_name_Key = "MODL_NAME";
  static const API_imageURL_Key = "image_url";
  static const API_type_Key = "type";
  static const API_cars_Key = "cars";
  static const API_brand_Key = "brand";
  static const API_year_Key = "MODL_YEAR";
  static const API_colors_Key = "colors";
  static const API_model_images_Key = "images";
  static const API_model_image_url_Key = "image_url";
  static const API_model_image_sort_Key = "MOIM_SORT";
  static const API_arbcName_Key = "MODL_ARBC_NAME";

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
      : _id = json[API_id_Key],
        _name = json[API_name_Key],
        _year = json[API_year_Key],
        _arbcName = json[API_arbcName_Key],
        _brand = Brand.fromJson(json[API_brand_Key]),
        _type = CarType.fromJson(json[API_type_Key]),
        _imageURL = json[API_imageURL_Key],
        _colorImages = [],
        _colors = [],
        _images = [],
        _cars = CarList() {
    if (json.containsKey(API_colors_Key) && json[API_colors_Key] is List<dynamic>) {
      json[API_colors_Key].forEach((e) {
        _colors.add(ModelColor.fromJson(e));
      });
    }
    if (json.containsKey(API_model_images_Key) && json[API_model_images_Key] is List<dynamic>) {
      json[API_model_images_Key].forEach((e) {
        _images.add(
            RevmoCarImage(imageURL: e[API_model_image_url_Key], sortingValue: e[API_model_image_sort_Key], isModelImage: true));
      });
    }
    if (loadCars && json.containsKey(API_cars_Key) && json[API_cars_Key] is List<dynamic>) {
      json[API_cars_Key].forEach((e) {
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
