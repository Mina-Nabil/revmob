import 'package:intl/intl.dart';
import 'package:revmo/models/model.dart';
import 'package:revmo/models/revmo_image.dart';

class Car implements Comparable {
  static final NumberFormat _formatter = NumberFormat("#,###", "en");

  //Api Keys
  static const String DB_id_KEY = "id";
  static const String DB_catgName_KEY = "CAR_CATG";
  static const String DB_avgPrice_KEY = "CAR_PRCE";
  static const String DB_horsePower_KEY = "CAR_HPWR";
  static const String DB_seats_KEY = "CAR_SEAT";
  static const String DB_sort_KEY = "CAR_VLUE";
  static const String DB_acceleration_KEY = "CAR_ACC";
  static const String DB_engineCC_KEY = "CAR_ENCC";
  static const String DB_torque_KEY = "CAR_TORQ";
  static const String DB_transmission_KEY = "CAR_TRNS";
  static const String DB_top_speed_KEY = "CAR_TPSP";
  static const String DB_height_KEY = "CAR_HEIT";
  static const String DB_rims_KEY = "CAR_RIMS";
  static const String DB_trunk_KEY = "CAR_TRNK";
  static const String DB_dimensions_KEY = "CAR_DIMN";
  static const String DB_paragraph_title1_KEY = "CAR_TTL1";
  static const String DB_paragraph_title2_KEY = "CAR_TTL2";
  static const String DB_paragraph1_KEY = "CAR_PRG1";
  static const String DB_paragraph2_KEY = "CAR_PRG2";
  static const String DB_main_image_KEY = "image_url";
  static const String DB_added_KEY = "created_at";

  static const String DB_carimage_url_KEY = "image_url";
  static const String DB_carimage_sort_KEY = "CIMG_VLUE";

  static const String DB_model_KEY = "model";
  static const String DB_images_KEY = "images";

  final int _id;
  final String _catgName;
  final double _avgPrice;
  final CarModel _model;
  final DateTime _added;
  final int _horsePower;
  final int _seats;
  final double _acceleration;
  final int _motorCC;
  final String _torque;
  final String _transmission;
  final int _topSpeed;
  final int _height;
  final int _rims;
  final int _trunkCapacity;
  final String _dimensions;
  final String _mainImageURL;
  final List<RevmoCarImage> _images;
  final String? _paragraph1Title;
  final String? _paragraph1;
  final String? _paragraph2Title;
  final String? _paragraph2;
  final int _sortValue;

  // Car(this.id, this.catgName, this.avgPrice, this.model, this.added);

  Car.fromJson(Map<String, dynamic> json, {CarModel? model})
      : _id = json[DB_id_KEY] ?? 1,
        _catgName = json[DB_catgName_KEY],
        _avgPrice = json[DB_avgPrice_KEY].toDouble(),
        _horsePower = json[DB_horsePower_KEY],
        _seats = json[DB_seats_KEY],
        _acceleration = json[DB_acceleration_KEY].toDouble(),
        _motorCC = json[DB_engineCC_KEY],
        _torque = json[DB_torque_KEY],
        _transmission = json[DB_transmission_KEY],
        _topSpeed = json[DB_top_speed_KEY],
        _height = json[DB_height_KEY],
        _rims = json[DB_rims_KEY],
        _trunkCapacity = json[DB_trunk_KEY],
        _dimensions = json[DB_dimensions_KEY],
        _mainImageURL = json[DB_main_image_KEY],
        _model = model ?? CarModel.fromJson(json[DB_model_KEY]),
        _paragraph1 = json[DB_paragraph1_KEY],
        _paragraph2 = json[DB_paragraph2_KEY],
        _paragraph1Title = json[DB_paragraph_title1_KEY],
        _paragraph2Title = json[DB_paragraph_title2_KEY],
        _sortValue = json[DB_sort_KEY],
        _images = [],
        _added = json[DB_added_KEY] ?? DateTime(2012) {
    assert(model != null || json.containsKey(DB_model_KEY), "Model shall be initialized with the Car object");
    _images.addAll(_model.images);
    if (json[DB_images_KEY] != null && json[DB_images_KEY] is Iterable<dynamic>) {
      json[DB_images_KEY].forEach((e) {
        _images.add(RevmoCarImage(imageURL: e[DB_carimage_url_KEY], sortingValue: e[DB_carimage_sort_KEY], isModelImage: false));
      });
    }
  }

  String get carName => model.brand.name + " " + model.name + " " + catgName + " " + model.year;
  String get modelName => model.brand.name + " " + model.name;

  String get formattedDate {
    return added.day.toString() + "/" + added.month.toString() + "/" + added.year.toString();
  }

  String get formattedPrice {
    return _formatter.format(avgPrice);
  }

  int get id => _id;
  String get catgName => _catgName;
  double get avgPrice => _avgPrice;
  CarModel get model => _model;
  DateTime get added => _added;
  int get horsePower => _horsePower;
  String get horsePowerString => _horsePower.toString() + " Hp";
  int get seats => _seats;
  int get sort => _sortValue;
  double get acceleration => _acceleration;
  int get motorCC => _motorCC;
  String get torque => _torque;
  String get transmission => _transmission;
  int get topSpeed => _topSpeed;
  int get height => _height;
  int get rims => _rims;
  int get trunkCapacity => _trunkCapacity;
  String get dimensions => _dimensions;
  String get mainImageURL => _mainImageURL;
  List<RevmoCarImage> get carImages => _images;
  String? get paragraphTitle1 => _paragraph1Title;
  String? get paragraph1 => _paragraph1;
  String? get paragraphTitle2 => _paragraph2Title;
  String? get paragraph2 => _paragraph2;
  bool get hasParagraph1 => _paragraph1 != null && _paragraph1Title != null;
  bool get hasParagraph2 => _paragraph2 != null && _paragraph2Title != null;

  String get desc1 => motorCC.toString() + "cc " + " - " + horsePowerString;
  String get desc2 => model.type.name + " - " + rims.toString() + "' Rims";

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
