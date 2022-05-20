import 'package:intl/intl.dart';
import 'package:revmo/models/accounts/buyer.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/model_color.dart';

enum OfferState { New, Accepted, Expired, Declined }

class Offer {
  static final NumberFormat _formatter = NumberFormat("######", "en");

  static const String API_id_Key = "id";
  static const String API_seller_Key = "seller";
  static const String API_buyer_Key = "buyer";
  static const String API_car_Key = "car";
  static const String API_colors_Key = "colors";
  static const String API_isLoan_Key = "OFFR_CAN_LOAN";
  static const String API_price_Key = "OFFR_PRCE";
  static const String API_downPayment_Key = "OFFR_MIN_PYMT";
  static const String API_startDate_Key = "OFFR_STRT_DATE";
  static const String API_expiryDate_Key = "OFFR_EXPR_DATE";
  static const String API_sellerComment_Key = "OFFR_SLLR_CMNT";
  static const String API_buyerComment_Key = "OFFR_BUYR_CMNT";
  static const String API_state_Key = "OFFR_STTS";
  static const String API_responseDate_Key = "OFFR_RSPN_DATE";

  static const String API_state_New_Value = "OFFR_STTS";
  static const String API_state_Accepted_Value = "Accepted";
  static const String API_state_Expired_Value = "Expired";
  static const String API_state_Declined_Value = "Declined";

  int _id;
  Seller _seller;
  Buyer _buyer;
  Car _car;
  OfferState _state;
  bool _isLoan;
  double _price;
  double _downPayment;
  DateTime _startDate;
  DateTime _expiryDate;
  String? _sellerComment;
  String? _buyerComment;
  DateTime? _buyerResponseDate;
  List<ModelColor> _colors;

  Offer.fromJson(json)
      : _id = json[API_id_Key],
        _seller = Seller.fromJson(json[API_seller_Key]),
        _buyer = Buyer.fromJson(json[API_buyer_Key]),
        _car = Car.fromJson(json[API_car_Key]),
        _state = (json[API_car_Key] == API_state_Accepted_Value)
            ? OfferState.Accepted
            : (json[API_car_Key] == API_state_New_Value)
                ? OfferState.New
                : (json[API_car_Key] == API_state_Declined_Value)
                    ? OfferState.Declined
                    : OfferState.Expired,
        _isLoan = json[API_isLoan_Key] == "1",
        _price = json[API_price_Key],
        _downPayment = json[API_downPayment_Key],
        _startDate = DateTime.tryParse(json[API_startDate_Key]) ?? DateTime.now(),
        _expiryDate = DateTime.tryParse(json[API_expiryDate_Key]) ?? DateTime.now(),
        _sellerComment = json[API_sellerComment_Key],
        _buyerComment = json[API_buyerComment_Key],
        _buyerResponseDate = DateTime.tryParse(json[API_responseDate_Key]),
        _colors = [] {
    if (json[API_colors_Key] != null && json[API_colors_Key] is Iterable<String>) {
      json[API_colors_Key].forEach((c) {
        _colors.add(ModelColor.fromJson(c));
      });
    }
  }
  int get id => _id;
  String get formattedID => "#" + _id.toString().padLeft(6, '0');
  Seller get seller => _seller;
  Buyer get buyer => _buyer;
  Car get car => _car;
  bool get isLoan => _isLoan;
  OfferState get state => _state;
  double get price => _price;
  double get downPayment => _downPayment;
  DateTime get issuingDate => _startDate;
  String get formatedIssuingDate =>
      _startDate.day.toString() + "/" + _startDate.month.toString() + "/" + _startDate.year.toString();
  DateTime get expiryDate => _expiryDate;
  String get formatedExpiryDate =>
      _expiryDate.day.toString() + "/" + _expiryDate.month.toString() + "/" + _expiryDate.year.toString();
  String? get sellerComment => _sellerComment;
  String? get buyerComment => _buyerComment;
  DateTime? get buyerResponseDate => _buyerResponseDate;
  List<ModelColor> get colors => _colors;
}
