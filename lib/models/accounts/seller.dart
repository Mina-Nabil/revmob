import 'package:intl/intl.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/profile.dart';
import 'package:revmo/models/accounts/showroom.dart';

class Seller implements Profile {
  static final NumberFormat _formatter = NumberFormat("#,###", "en");
  static const String API_ID = "id";
  static const String API_NAME_Key = "SLLR_NAME";
  static const String API_MOB_Key = "SLLR_MOB1";
  static const String API_MAIL_Key = "SLLR_MAIL";
  static const String API_MOB_VRFD_Key = "SLLR_MOB1_VRFD";
  static const String API_MAIL_VRFD_Key = "SLLR_MAIL_VRFD";
  static const String API_CAN_MNG_Key = "SLLR_CAN_MNGR";
  static const String API_INVITED_Key = "JNRQ_STTS"; //showroom invitation status
  static const String API_IMG_Key = "image_url";
  static const String API_TOTAL_SALES_Key = "cars_sold_price";
  static const String API_SALES_COUNT_Key = "cars_sold_count";
  static const String API_showroom_Key = "showroom";

  static const String FORM_IDENTIFIER_Key = "identifier";
  static const String FORM_NAME_Key = "name";
  static const String FORM_EMAIL_Key = "email";
  static const String FORM_MOB_Key = "mobNumber1";
  static const String FORM_IMGE_Key = "image";
  static const String FORM_PW_Key = "password";

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
      : _id = json[Seller.API_ID],
        _fullName = json[Seller.API_NAME_Key] ?? "noID",
        _mob = json[Seller.API_MOB_Key] ?? "noID",
        _email = json[Seller.API_MAIL_Key] ?? "noID",
        _image = json[Seller.API_IMG_Key],
        _totalSoldCars = json[Seller.API_SALES_COUNT_Key],
        _salesTotal = json[Seller.API_TOTAL_SALES_Key].toDouble(),
        _isMobVerified = json[Seller.API_MOB_VRFD_Key] == 1,
        _isEmailVerified = json[Seller.API_MAIL_VRFD_Key] == 1,
        _canManage = json[Seller.API_CAN_MNG_Key] == 1,
        showroom = (loadedShowroom != null)
            ? loadedShowroom
            : (json[API_showroom_Key] != null)
                ? Showroom.fromJson(json[API_showroom_Key])
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

  String get initials {
    String ret = "";
    _fullName.split(" ").forEach((name) {
      ret += name[0].toUpperCase();
    });
    return ret;
  }

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
