class OfferDefaults {
  static const API_noOfDays_Key = "SRCG_MAX_DAYS";
  static const API_minPayments_Key = "SRCG_MIN_PYMT";
  static const API_carPrice_Key = "SRCG_DEF_PRCE";

  final int _noOfDays;
  final int _minPayment;
  final int _carPrice;

  OfferDefaults(int defaultNumberOfDaysStartingToday, int carPrice, int minPayment)
      : _noOfDays = defaultNumberOfDaysStartingToday,
        _carPrice = carPrice,
        _minPayment = minPayment;

  OfferDefaults.fromJson(Map<String, dynamic> json)
      : _noOfDays = json[API_noOfDays_Key] ?? 7,
        _carPrice = json[API_carPrice_Key] ?? 0,
        _minPayment = json[API_minPayments_Key] ?? 0;

  int get noOfDays => _noOfDays;
  int get minPayment => _minPayment;
  int get carPrice => _carPrice;
}
