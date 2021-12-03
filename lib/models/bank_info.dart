class BankInfo {
  static const String DB_id_KET = "id";
  static const String DB_branchName_KEY = "BANK_";
  static const String DB_accountNumber_KEY = "BANK_ACNT";
  static const String DB_holderName_KEY = "BANK_BRCH";
  static const String DB_iban_KEY = "BANK_IBAN";

  String _branchName;
  String _accountNumber;
  String _holderName;
  String _iban;

  BankInfo.fromJson(Map<String, dynamic> json)
      : this._branchName = json[DB_branchName_KEY],
        this._accountNumber = json[DB_accountNumber_KEY],
        this._holderName = json[DB_holderName_KEY],
        this._iban = json[DB_iban_KEY];
}
