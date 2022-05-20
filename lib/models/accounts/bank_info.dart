class BankInfo {
  static const String API_id_KET = "id";
  static const String API_branchName_Key = "BANK_";
  static const String API_accountNumber_Key = "BANK_ACNT";
  static const String API_holderName_Key = "BANK_BRCH";
  static const String API_iban_Key = "BANK_IBAN";

  String _branchName;
  String _accountNumber;
  String _holderName;
  String _iban;

  BankInfo.fromJson(Map<String, dynamic> json)
      : this._branchName = json[API_branchName_Key],
        this._accountNumber = json[API_accountNumber_Key],
        this._holderName = json[API_holderName_Key],
        this._iban = json[API_iban_Key];
}
