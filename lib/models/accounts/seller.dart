import 'package:intl/intl.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/showroom.dart';

class Seller {
  static final NumberFormat _formatter = NumberFormat("#,###", "en");
  static const String DB_ID = "id";
  static const String DB_NAME_KEY = "SLLR_NAME";
  static const String DB_MOB_KEY = "SLLR_MOB1";
  static const String DB_MAIL_KEY = "SLLR_MAIL";
  static const String DB_MOB_VRFD_KEY = "SLLR_MOB1_VRFD";
  static const String DB_MAIL_VRFD_KEY = "SLLR_MAIL_VRFD";
  static const String DB_CAN_MNG_KEY = "SLLR_CAN_MNGR";
  static const String DB_INVITED_KEY = "JNRQ_STTS"; //showroom invitation status
  static const String DB_IMG_KEY = "image_url";
  static const String DB_TOTAL_SALES_KEY = "cars_sold_price";
  static const String DB_SALES_COUNT_KEY = "cars_sold_count";
  static const String DB_showroom_KEY = "showroom";


  static const String FORM_IDENTIFIER_KEY = "identifier";
  static const String FORM_NAME_KEY = "name";
  static const String FORM_EMAIL_KEY = "email";
  static const String FORM_MOB_KEY = "mobNumber1";
  static const String FORM_IMGE_KEY = "image";
  static const String FORM_PW_KEY = "password";

  final int _id;
  String _fullName;
  String _email;
  String _mob;
  String? _image;
  bool _isMobVerified;
  bool _isEmailVerified;
  bool inTeam;
  JoinRequestStatus? requestedStatus;
  bool _canManage;
  Showroom? showroom;
  int _totalSoldCars;
  double _salesTotal;

  Seller(
      {required int id,
      required String fullName,
      required String email,
      required String mob,
      required String image,
      double totalSales = 0,
      int soldCars = 0,
      bool isMobVerified = false,
      bool canManage = false,
      this.inTeam = false,
      bool isEmailVerified = false})
      : _id = id,
        _fullName = fullName,
        _email = email,
        _mob = mob,
        _image = image,
        _isEmailVerified = isEmailVerified,
        _totalSoldCars = soldCars,
        _salesTotal = totalSales,
        _canManage = canManage,
        _isMobVerified = isMobVerified;

  Seller.fromJson(Map<String, dynamic> json, {Showroom? loadedShowroom, this.inTeam = false, this.requestedStatus})
      : _id = json[Seller.DB_ID],
        _fullName = json[Seller.DB_NAME_KEY] ?? "noID",
        _mob = json[Seller.DB_MOB_KEY] ?? "noID",
        _email = json[Seller.DB_MAIL_KEY] ?? "noID",
        _image = json[Seller.DB_IMG_KEY],
        _totalSoldCars = json[Seller.DB_SALES_COUNT_KEY],
        _salesTotal = json[Seller.DB_TOTAL_SALES_KEY].toDouble(),
        _isMobVerified = json[Seller.DB_MOB_VRFD_KEY] == 1,
        _isEmailVerified = json[Seller.DB_MAIL_VRFD_KEY] == 1,
        _canManage = json[Seller.DB_CAN_MNG_KEY] == 1,
        showroom = (loadedShowroom != null)
            ? loadedShowroom
            : (json[DB_showroom_KEY] != null)
                ? Showroom.fromJson(json[DB_showroom_KEY])
                : null;

  updateInfo({required String imagefullName, required String email, required String mob}) {
    this._fullName = fullName;
    this._email = email;
    this._mob = mob;
  }

  verifyEmail() {
    _isEmailVerified = true;
  }

  verifyMobile() {
    _isMobVerified = true;
  }

  bool contains(String searchText) => _fullName.contains(searchText) || _mob.contains(searchText);

  int get id => _id;
  String get fullName => _fullName;
  String get email => _email;
  String get mob => _mob;
  String? get image => _image;
  bool get isEmailVerified => _isEmailVerified;
  bool get isMobVerified => _isMobVerified;
  double get salesTotal => _salesTotal;
  String get salesTotalFormatted => (_formatter.format((_salesTotal) / 1000)) + "k";
  int get carsSoldCount => _totalSoldCars;
  bool get canManage => _canManage || isOwner;
  bool get managerNotOwner => _canManage && !isOwner;
  bool get isOwner => showroom != null && this.id == showroom!.ownerID;
  bool get hasShowroom => (showroom != null && showroom is Showroom && showroom!.id > 0);

  operator ==(Object? s) {
    return s is Seller && s.hashCode == this.hashCode;
  }

  @override
  int get hashCode => this.id.hashCode;

  @override
  String toString() {
    return fullName;
  }
}
