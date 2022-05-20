import 'package:revmo/models/accounts/profile.dart';
import 'package:revmo/models/accounts/showroom.dart';

class Buyer implements Profile {
  static const String API_ID = "id";
  static const String API_NAME_Key = "BUYR_NAME";
  static const String API_MOB_Key = "BUYR_MOB1";
  static const String API_MAIL_Key = "BUYR_MAIL";
  static const String API_MOB_VRFD_Key = "BUYR_MOB1_VRFD";
  static const String API_MAIL_VRFD_Key = "BUYR_MAIL_VRFD";
  static const String API_CAN_MNG_Key = "BUYR_CAN_MNGR";
  static const String API_IMG_Key = "image_url";

  final int _id;
  String _fullName;
  String _email;
  String _mob;
  String? _image;
  bool _isMobVerified;
  bool _isEmailVerified;

  Buyer(
      {required int id,
      required String fullName,
      required String email,
      required String mob,
      required String image,
      bool isMobVerified = false,
      bool isEmailVerified = false})
      : _id = id,
        _fullName = fullName,
        _email = email,
        _mob = mob,
        _image = image,
        _isEmailVerified = isEmailVerified,
        _isMobVerified = isMobVerified;

  Buyer.fromJson(Map<String, dynamic> json)
      : _id = json[API_ID],
        _fullName = json[API_NAME_Key] ?? "noID",
        _mob = json[API_MOB_Key] ?? "noID",
        _email = json[API_MAIL_Key] ?? "noID",
        _image = json[API_IMG_Key],
        _isMobVerified = json[API_MOB_VRFD_Key] == 1,
        _isEmailVerified = json[API_MAIL_VRFD_Key] == 1;

  updateInfo({required String imagefullName, required String email, required String mob}) {
    this._fullName = fullName;
    this._email = email;
    this._mob = mob;
  }

  bool contains(String searchText) => _fullName.contains(searchText) || _mob.contains(searchText);

  int get id => _id;
  String get fullName => _fullName;
  String get email => _email;
  String get mob => _mob;
  String? get image => _image;
  bool get isEmailVerified => _isEmailVerified;
  bool get isMobVerified => _isMobVerified;
  Showroom? get showroom => null;

  operator ==(Object? b) {
    return b is Buyer && b.hashCode == this.hashCode;
  }

  String get initials {
    String ret = "";
    _fullName.split(" ").forEach((name) {
      ret += name[0].toUpperCase();
    });
    return ret;
  }

  @override
  int get hashCode => this.id.hashCode;

  @override
  String toString() => fullName;
}
