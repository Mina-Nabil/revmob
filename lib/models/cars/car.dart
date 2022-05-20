import 'package:intl/intl.dart';
import 'car_accessory.dart';
import 'model.dart';
import 'revmo_image.dart';

class Car implements Comparable {
  static final NumberFormat _formatter = NumberFormat("#,###", "en");

  //Api Keys
  static const String API_id_Key = "id";
  static const String API_catgName_Key = "CAR_CATG";
  static const String API_avgPrice_Key = "CAR_PRCE";
  static const String API_horsePower_Key = "CAR_HPWR";
  static const String API_seats_Key = "CAR_SEAT";
  static const String API_sort_Key = "CAR_VLUE";
  static const String API_acceleration_Key = "CAR_ACC";
  static const String API_engineCC_Key = "CAR_ENCC";
  static const String API_torque_Key = "CAR_TORQ";
  static const String API_transmission_Key = "CAR_TRNS";
  static const String API_top_speed_Key = "CAR_TPSP";
  static const String API_height_Key = "CAR_HEIT";
  static const String API_rims_Key = "CAR_RIMS";
  static const String API_trunk_Key = "CAR_TRNK";
  static const String API_dimensions_Key = "CAR_DIMN";
  static const String API_paragraph_title1_Key = "CAR_TTL1";
  static const String API_paragraph_title2_Key = "CAR_TTL2";
  static const String API_paragraph1_Key = "CAR_PRG1";
  static const String API_paragraph2_Key = "CAR_PRG2";
  static const String API_main_image_Key = "image_url";
  static const String API_added_Key = "created_at";

  static const String API_carimage_url_Key = "image_url";
  static const String API_carimage_sort_Key = "CIMG_VLUE";

  static const String API_model_Key = "model";
  static const String API_images_Key = "images";
  static const String API_accessories_Key = "accessories";

  final int _id;
  final String _catgName;
  final double _avgPrice;
  final CarModel _model;
  final DateTime _added;
  final int _horsePower;
  final int _seats;
  final double _acceleration;
  final String _motorCC;
  final String _torque;
  final String _transmission;
  final int _topSpeed;
  final double _height;
  final int _rims;
  final int _trunkCapacity;
  final String _dimensions;
  final String _mainImageURL;
  final List<RevmoCarImage> _images;
  final List<CarAccessory> _accessories;
  final String? _paragraph1Title;
  final String? _paragraph1;
  final String? _paragraph2Title;
  final String? _paragraph2;
  final int _sortValue;

  // Car(this.id, this.catgName, this.avgPrice, this.model, this.added);

  Car.fromJson(Map<String, dynamic> json, {CarModel? model})
      : _id = json[API_id_Key] ?? 1,
        _catgName = json[API_catgName_Key],
        _avgPrice = json[API_avgPrice_Key].toDouble(),
        _horsePower = json[API_horsePower_Key],
        _seats = json[API_seats_Key],
        _acceleration = json[API_acceleration_Key].toDouble(),
        _motorCC = json[API_engineCC_Key],
        _torque = json[API_torque_Key],
        _transmission = json[API_transmission_Key],
        _topSpeed = json[API_top_speed_Key],
        _height = json[API_height_Key] is double ? json[API_height_Key] : double.parse(json[API_height_Key].toString()),
        _rims = json[API_rims_Key],
        _trunkCapacity = json[API_trunk_Key],
        _dimensions = json[API_dimensions_Key],
        _mainImageURL = json[API_main_image_Key],
        _model = model ?? CarModel.fromJson(json[API_model_Key]),
        _paragraph1 = json[API_paragraph1_Key],
        _paragraph2 = json[API_paragraph2_Key],
        _paragraph1Title = json[API_paragraph_title1_Key],
        _paragraph2Title = json[API_paragraph_title2_Key],
        _sortValue = json[API_sort_Key],
        _images = [],
        _accessories = [],
        _added = json[API_added_Key] != null ? (DateTime.tryParse(json[API_added_Key]) ?? DateTime.now()) : DateTime.now() {
    assert(model != null || json.containsKey(API_model_Key), "Model shall be initialized with the Car object");
    _images.addAll(_model.images);
    if (json[API_images_Key] != null && json[API_images_Key] is Iterable<dynamic>) {
      json[API_images_Key].forEach((e) {
        _images
            .add(RevmoCarImage(imageURL: e[API_carimage_url_Key], sortingValue: e[API_carimage_sort_Key], isModelImage: false));
      });
    }
    if (json[API_accessories_Key] != null && json[API_accessories_Key] is Iterable<dynamic>) {
      json[API_accessories_Key].forEach((e) {
        _accessories.add(new CarAccessory.fromJson(e));
      });
    }
  }

  String get carName => model.brand.name + " " + model.name + " " + catgName + " " + model.year;
  String get modelName => model.brand.name + " " + model.name;

  String get formattedDate => _added.day.toString() + "/" + _added.month.toString() + "/" + _added.year.toString();

  String get formattedPrice {
    return _formatter.format(avgPrice);
  }

  int get id => _id;
  String get catgName => _catgName;
  double get avgPrice => _avgPrice;
  CarModel get model => _model;
  DateTime get addedDate => _added;
  int get horsePower => _horsePower;
  String get horsePowerString => _horsePower.toString() + " Hp";
  int get seats => _seats;
  int get sort => _sortValue;
  double get acceleration => _acceleration;
  String get motorCC => _motorCC;
  String get torque => _torque;
  String get transmission => _transmission;
  int get topSpeed => _topSpeed;
  double get height => _height;
  int get rims => _rims;
  int get trunkCapacity => _trunkCapacity;
  String get dimensions => _dimensions;
  String get mainImageURL => _mainImageURL;
  List<RevmoCarImage> get carImages => _images;
  List<CarAccessory> get accessories => _accessories;
  String? get paragraphTitle1 => _paragraph1Title;
  String? get paragraph1 => _paragraph1;
  String? get paragraphTitle2 => _paragraph2Title;
  String? get paragraph2 => _paragraph2;
  bool get hasParagraph1 => _paragraph1 != null && _paragraph1Title != null;
  bool get hasParagraph2 => _paragraph2 != null && _paragraph2Title != null;

  String get desc1 => motorCC.toString() + "cc " + " - " + horsePowerString;
  String get desc2 => model.type.name + " - " + rims.toString() + "' Rims";

  bool hasText(String searchText) {
    searchText = searchText.toLowerCase();
    return _catgName.toLowerCase().contains(searchText) ||
        _model.name.toLowerCase().contains(searchText) ||
        _model.brand.name.toLowerCase().contains(searchText) ||
        _model.arbcName.toLowerCase().contains(searchText) ||
        _model.brand.arbcName.toLowerCase().contains(searchText);
  }

  operator ==(o) {
    return o is Car && id == o.id;
  }

  @override
  int get hashCode => model.hashCode ^ id.hashCode;

  @override
  int compareTo(other) {
    assert(other is Car, "Comparing to a non Car object");
    if (this.sort < other.sort)
      return -1;
    else if (this.sort > other.sort)
      return 1;
    else
      return 0;
  }

  @override
  String toString() {
    return this.carName;
  }

  /*
  static List<Car> get testdata {
    CarType type1 = CarType(1, "H/B", "هاتش باك");
    CarType type2 = CarType(2, "Sedan", "سيدان");
    return [
      new Car(
        "Active",
        200000,
        new CarModel(
            "3008",
            "https://ymimg1.b8cdn.com/uploads/car_model/2751/pictures/2891762/01.jpg",
            new Brand(1, "Peageot", "بيجو",
                "https://cdn.freelogovectors.net/wp-content/uploads/2021/02/peugeot-new-logo-freelogovectors.net_.png"),
            type1,
            "2022",
            "٣٠٠٨"),
        new DateTime.now(),
      ),
      new Car(
          "HighLine",
          200000,
          new CarModel(
              "312i",
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2Sd7QKdQzkX1d059B2uu5iwsCVmYMDuO2Cso4A9Qd84DyknyGred9Q0aNMw0n8vLFrYc&usqp=CAU",
              new Brand(2, "BMW", "بورشه",
                  "https://mpng.subpng.com/20180427/oxq/kisspng-bmw-m3-car-land-rover-logo-bmw-vector-5ae39b4cef4d91.6942117715248658689802.jpg"),
              type2,
              "2021",
              "٣١٨"),
          new DateTime.now()),
      new Car(
        "High Line",
        12000000,
        new CarModel(
            "C-180",
            "https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
            new Brand(3, "Mercedes", "بورشه",
                "https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Mercedes-Logo.svg/1200px-Mercedes-Logo.svg.png"),
            type2,
            "2001",
            "سي ١٨٠"),
        DateTime.now(),
      ),
      new Car(
          "Base Line",
          10000000,
          new CarModel(
              "C-180",
              "https://images.pexels.com/photos/112460/pexels-photo-112460.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
              new Brand(4, "Mercedes", "بورشه",
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Mercedes-Logo.svg/1200px-Mercedes-Logo.svg.png"),
              type1,
              "2018",
              "سي"),
          DateTime.now()),
      new Car(
          "GT3",
          10000000000,
          new CarModel(
              "911",
              "https://files.porsche.com/filestore/image/multimedia/none/992-gt3-modelimage-sideshot/model/765dfc51-51bc-11eb-80d1-005056bbdc38/porsche-model.png",
              new Brand(5, "Porsche", "بورشه",
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCGJptTC88mVAju4eIYP4Lz5ux36HRzLJMXw&usqp=CAU"),
              type2,
              "2022",
              "تمام"),
          DateTime.now()),
    ];
  }
  */
}
