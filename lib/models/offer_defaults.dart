class OfferDefaults {
  static const DB_noOfDays_key = "SRCG_MAX_DAYS";
  static const DB_minPayments_key = "SRCG_MAX_DAYS";
  static const DB_carPrice_key = "SRCG_DEF_PRCE";

  final int _noOfDays;
  final int _minPayment;
  final int _carPrice;

  OfferDefaults(int defaultNumberOfDaysStartingToday, int carPrice, int minPayment)
      : _noOfDays = defaultNumberOfDaysStartingToday,
        _carPrice = carPrice,
        _minPayment = minPayment;

  OfferDefaults.fromJson(Map<String, dynamic> json)
      : _noOfDays = json[DB_noOfDays_key] ?? 7,
        _carPrice = json[DB_carPrice_key] ?? 0,
        _minPayment = json[DB_minPayments_key] ?? 0;

  int get noOfDays => _noOfDays;
  int get minPayment => _minPayment;
  int get carPrice => _carPrice;
}
