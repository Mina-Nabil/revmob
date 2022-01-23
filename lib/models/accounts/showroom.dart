import 'package:revmo/models/accounts/bank_info.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/seller.dart';

class Showroom {
  static const String DB_ID = "id";
  static const String DB_OWNR_ID_KEY = "SHRM_OWNR_ID";
  static const String DB_CITY_ID_KEY = "SHRM_CITY_ID";
  static const String DB_BANK_ID_KEY = "SHRM_BANK_ID";
  static const String DB_name_KEY = "SHRM_NAME";
  static const String DB_email_KEY = "SHRM_MAIL";
  static const String DB_address_KEY = "SHRM_ADRS";
  static const String DB_mobileNumber1_KEY = "SHRM_MOB1";
  static const String DB_isVerified_KEY = "SHRM_VRFD";
  static const String DB_isActive_KEY = "SHRM_ACTV";
  static const String DB_isMailVerified_KEY = "SHRM_MAIL_VRFD";
  static const String DB_isMobVerified_KEY = "SHRM_MOB1_VRFD";

  static const String DB_salesRecord_KEY = "SHRM_RECD";
  static const String DB_salesRecordStatus_KEY = "SHRM_RECD_STTS";

  static const String DB_salesRecordFrontImg_KEY = "SHRM_RECD_FRNT";
  static const String DB_salesRecordBackImg_KEY = "SHRM_RECD_BACK";

  static const String DB_verifiedSince_KEY = "SHRM_VRFD_SNCE";

  static const String DB_balance_KEY = "SHRM_BLNC";

  static const String DB_image_KEY = "image_url";
  static const String DB_owner_KEY = "owner";

  static const String DB_offerSent_KEY = "SHRM_OFRS_SENT";
  static const String DB_offersAccepted_KEY = "SHRM_OFRS_ACPT";
  static const String DB_createdAt_KEY = "created_at";

  static const String FORM_NAME_KEY = "name";
  static const String FORM_EMAIL_KEY = "email";
  static const String FORM_MOB_KEY = "mobNumber1";
  static const String FORM_IMGE_KEY = "image";
  static const String FORM_PW_KEY = "password";
  static const String FORM_ADRS_KEY = "address";
  static const String FORM_CITY_KEY = "cityID";

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
      : this._id = json[DB_ID],
        this._name = json[DB_name_KEY],
        this._ownerID = json[DB_OWNR_ID_KEY],
        this._address = json[DB_address_KEY],
        this._balance = json[DB_balance_KEY].toDouble(),
        this._bankID = json[DB_BANK_ID_KEY],
        this._cityID = (json[DB_CITY_ID_KEY] is int) ? json[DB_CITY_ID_KEY] : int.parse(json[DB_CITY_ID_KEY]),
        this._createdAt = DateTime.parse(json[DB_createdAt_KEY]),
        this._email = json[DB_email_KEY],
        this._image = json[DB_image_KEY],
        this._isActive = json[DB_isActive_KEY] == 1,
        this._isMailVerified = json[DB_isMailVerified_KEY] == 1,
        this._isMobVerified = json[DB_isMobVerified_KEY] == 1,
        this._isVerified = json[DB_isVerified_KEY] == 1,
        this._mobileNumber1 = json[DB_mobileNumber1_KEY],
        this._offersAccepted = json[DB_offersAccepted_KEY] ?? 0,
        this._offersSent = json[DB_offerSent_KEY] ?? 0,
        this._salesRecord = json[DB_salesRecord_KEY],
        this._salesRecordBackImg = json[DB_salesRecordBackImg_KEY],
        this._salesRecordFrontImg = json[DB_salesRecordFrontImg_KEY],
        this._salesRecordStatus = json[DB_salesRecordStatus_KEY],
        this._verifiedSince = DateTime.tryParse(json[DB_verifiedSince_KEY] ?? "") {
    this._owner = json[DB_owner_KEY] != null ? Seller.fromJson(json[DB_owner_KEY], loadedShowroom: this) : null;
  }

  int get id => _id;
  int get ownerID => _ownerID;
  int get cityID => _cityID;
  String get name => _name;
  String get email => _email;
  String get address => _address;
  String get mobNumber => _mobileNumber1;
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

  BankInfo? get bankingInfo => _bankingInfo;

  set bankingInfo(BankInfo? info) => this._bankingInfo = info;

  operator ==(o) => o.hashCode == this.hashCode;

  @override
  int get hashCode => id.hashCode;
}
