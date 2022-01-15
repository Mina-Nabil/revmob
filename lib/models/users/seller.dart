import 'package:revmo/models/cars/showroom.dart';

class Seller {
  static const String DB_ID = "id";
  static const String DB_NAME_KEY = "SLLR_NAME";
  static const String DB_MOB_KEY = "SLLR_MOB1";
  static const String DB_MAIL_KEY = "SLLR_MAIL";
  static const String DB_IMG_KEY = "SLLR_IMGE";
  static const String DB_MOB_VRFD_KEY = "SLLR_MOB1_VRFD";
  static const String DB_MAIL_VRFD_KEY = "SLLR_MAIL_VRFD";
  static const String DB_CAN_MNG_KEY = "SLLR_CAN_MNGR";
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
  bool _canManage;
  Showroom? _showroom;

  Seller(
      {required int id,
      required String fullName,
      required String email,
      required String mob,
      required String image,
      bool isMobVerified = false,
      bool canManage = false,
      bool isEmailVerified = false})
      : _id = id,
        _fullName = fullName,
        _email = email,
        _mob = mob,
        _image = image,
        _isEmailVerified = isEmailVerified,
        _canManage = canManage,
        _isMobVerified = isMobVerified;

  Seller.fromJson(Map<String, dynamic> json)
      : _id = json[Seller.DB_ID] ?? 1212,
        _fullName = json[Seller.DB_NAME_KEY] ?? "noID",
        _mob = json[Seller.DB_MOB_KEY] ?? "noID",
        _email = json[Seller.DB_MAIL_KEY] ?? "noID",
        _image = json[Seller.DB_IMG_KEY],
        _isMobVerified = json[Seller.DB_MOB_VRFD_KEY] == 1,
        _isEmailVerified = json[Seller.DB_MAIL_VRFD_KEY] == 1,
        _canManage = json[Seller.DB_CAN_MNG_KEY] == 1,
        _showroom=(json[DB_showroom_KEY] != null) ? Showroom.fromJson(json[DB_showroom_KEY]) : null;

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

  int get id => _id;
  String get fullName => _fullName;
  String get email => _email;
  String get mob => _mob;
  String? get image => _image;
  Showroom? get showroom => _showroom;
  bool get isEmailVerified => _isEmailVerified;
  bool get isMobVerified => _isMobVerified;
  bool get canManage => _canManage;
  bool get hasShowroom => (showroom != null && showroom is Showroom && showroom!.id > 0);
}
