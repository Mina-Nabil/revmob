import 'dart:collection';

import 'package:revmo/models/accounts/buyer.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/model_color.dart';

import '../cars/available_options.dart';

enum PaymentType { CASH, LOAN }

class OfferRequest {
  static const String API_id_Key = "id";
  static const String API_buyer_Key = "buyer";
  static const String API_car_Key = "car";
  static const String API_colors_Key = "colors";
  static const String API_comment_Key = "OFRQ_CMNT";
  static const String API_createdAt_Key = "created_at";
  static const String API_paymentType_Key = "OFRQ_PRFD_PYMT";

  static const String API_paymentType_cash_value = "Cash";
  static const String API_paymentType_loan_value = "Loan";

  int _id;
  Buyer _buyer;
  Car _car;
  List<ModelColor> _colors;
  String? _comment;
  PaymentType _paymentType;
  DateTime _creationDate;
  List<AvailableOption> _availableOptions;

  OfferRequest.fromJson(json)
      : _id = json[API_id_Key],
        _buyer = Buyer.fromJson(json[API_buyer_Key]),
        _car = Car.fromJson(json[API_car_Key]),
        _comment = json[API_comment_Key],
        _availableOptions = json["available_options"] == null
            ? []
            : List<AvailableOption>.from(json["available_options"]
            .map((x) => AvailableOption.fromJson(x))),
        _paymentType = json[API_paymentType_Key] == API_paymentType_loan_value ? PaymentType.LOAN : PaymentType.CASH,
        _creationDate = DateTime.tryParse(json[API_createdAt_Key]) ?? DateTime.now(),
        _colors = [] {
    if (json[API_colors_Key] != null && json[API_colors_Key] is Iterable<dynamic>) {
      json[API_colors_Key].forEach((c) {
        _colors.add(ModelColor.fromJson(c["model_color"]));
      });
    }
  }

  int get id => _id;
  String get formatedID => "#" + _id.toString().padLeft(6, '0');
  Buyer get buyer => _buyer;
  Car get car => _car;
  List<ModelColor> get colors => _colors;
  String? get comment => _comment;
  PaymentType get paymentType => _paymentType;
  DateTime get createdDate => _creationDate;
  String get formatedDate =>
      _creationDate.day.toString() + "/" + _creationDate.month.toString() + "/" + _creationDate.year.toString();
  List<AvailableOption> get availableOptions => _availableOptions;

  bool validateSelectedOptions(HashMap<String, HashSet<String>> selectedSet){
    int selectedItems = 0;
    selectedSet.forEach((category, selectedOptions) {
      if(selectedOptions.isNotEmpty) selectedItems++;
    });
    return selectedItems == (availableOptions.length ?? 0);
  }
}
