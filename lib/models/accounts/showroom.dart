import 'package:revmo/models/accounts/bank_info.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/profile.dart';
import 'package:revmo/models/accounts/seller.dart';

class Showroom implements Profile {
  static const String API_ID = "id";
  static const String API_OWNR_ID_Key = "SHRM_OWNR_ID";
  static const String API_CITY_ID_Key = "SHRM_CITY_ID";
  static const String API_BANK_ID_Key = "SHRM_BANK_ID";
  static const String API_name_Key = "SHRM_NAME";
  static const String API_email_Key = "SHRM_MAIL";
  static const String API_address_Key = "SHRM_ADRS";
  static const String API_mobileNumber1_Key = "SHRM_MOB1";
  static const String API_isVerified_Key = "SHRM_VRFD";
  static const String API_isActive_Key = "SHRM_ACTV";
  static const String API_isMailVerified_Key = "SHRM_MAIL_VRFD";
  static const String API_isMobVerified_Key = "SHRM_MOB1_VRFD";

  static const String API_salesRecord_Key = "SHRM_RECD";
  static const String API_salesRecordStatus_Key = "SHRM_RECD_STTS";

  static const String API_salesRecordFrontImg_Key = "SHRM_RECD_FRNT";
  static const String API_salesRecordBackImg_Key = "SHRM_RECD_BACK";

  static const String API_verifiedSince_Key = "SHRM_VRFD_SNCE";

  static const String API_balance_Key = "SHRM_BLNC";

  static const String API_image_Key = "image_url";
  static const String API_owner_Key = "owner";

  static const String API_offerSent_Key = "SHRM_OFRS_SENT";
  static const String API_offersAccepted_Key = "SHRM_OFRS_ACPT";
  static const String API_createdAt_Key = "created_at";

  static const String FORM_NAME_Key = "name";
  static const String FORM_EMAIL_Key = "email";
  static const String FORM_MOB_Key = "mobNumber1";
  static const String FORM_IMGE_Key = "image";
  static const String FORM_PW_Key = "password";
  static const String FORM_ADRS_Key = "address";
  static const String FORM_CITY_Key = "cityID";

  final int _id;
  final int _ownerID;
  final int _cityID;
  String _name;
  String _email;
  String _address;
  String _mobileNumber1;
  bool _isVerified;
  bool _isActive;
  bool _isMailVerified;
  bool _isMobVerified;
  String? _salesRecordBackImg;
  DateTime? _verifiedSince;
  double _balance;
  String? _image;
  int _offersSent;
  int _offersAccepted;
  DateTime _createdAt;
  String? _salesRecord;
  String _salesRecordStatus;
  String? _salesRecordFrontImg;
  int? _bankID;
  BankInfo? _bankingInfo;
  Seller? _owner;
  JoinRequestStatus? requestedStatus;

  Showroom.fromJson(Map<String, dynamic> json, {this.requestedStatus})
      : this._id = json[API_ID],
        this._name = json[API_name_Key],
        this._ownerID = json[API_OWNR_ID_Key],
        this._address = json[API_address_Key],
        this._balance = json[API_balance_Key].toDouble(),
        this._bankID = json[API_BANK_ID_Key],
        this._cityID = (json[API_CITY_ID_Key] is int) ? json[API_CITY_ID_Key] : int.parse(json[API_CITY_ID_Key]),
        this._createdAt = DateTime.parse(json[API_createdAt_Key]),
        this._email = json[API_email_Key],
        this._image = json[API_image_Key],
        this._isActive = json[API_isActive_Key] == 1,
        this._isMailVerified = json[API_isMailVerified_Key] == 1,
        this._isMobVerified = json[API_isMobVerified_Key] == 1,
        this._isVerified = json[API_isVerified_Key] == 1,
        this._mobileNumber1 = json[API_mobileNumber1_Key],
        this._offersAccepted = json[API_offersAccepted_Key] ?? 0,
        this._offersSent = json[API_offerSent_Key] ?? 0,
        this._salesRecord = json[API_salesRecord_Key],
        this._salesRecordBackImg = json[API_salesRecordBackImg_Key],
        this._salesRecordFrontImg = json[API_salesRecordFrontImg_Key],
        this._salesRecordStatus = json[API_salesRecordStatus_Key],
        this._verifiedSince = DateTime.tryParse(json[API_verifiedSince_Key] ?? "") {
    this._owner = json[API_owner_Key] != null ? Seller.fromJson(json[API_owner_Key], loadedShowroom: this) : null;
  }

  int get id => _id;
  int get ownerID => _ownerID;
  int get cityID => _cityID;
  String get fullName => _name;
  String get email => _email;
  String get address => _address;
  String get mob => _mobileNumber1;
  bool get isVerified => _isVerified;
  bool get isActive => _isActive;
  bool get isMailVerified => _isMailVerified;
  bool get isMobVerified => _isMobVerified;
  DateTime? get verifiedSince => _verifiedSince;
  double get balance => _balance;
  String? get image => _image;
  int get offerSent => _offersSent;
  int get offersAccepted => _offersAccepted;
  DateTime get createdAt => _createdAt;
  String? get salesRecord => _salesRecord;
  String get salesRecordStatus => _salesRecordStatus;
  String? get salesRecordFrontImg => _salesRecordFrontImg;
  String? get salesRecordBackImg => _salesRecordBackImg;
  int? get bankID => _bankID;
  Seller? get owner => _owner;
  Showroom? get showroom => this;

  BankInfo? get bankingInfo => _bankingInfo;

  set bankingInfo(BankInfo? info) => this._bankingInfo = info;

  String get initials {
    String ret = "";
    _name.split(" ").forEach((name) {
      ret += name[0].toUpperCase();
    });
    return ret;
  }

  operator ==(o) => o.hashCode == this.hashCode;

  @override
  int get hashCode => id.hashCode;
}
