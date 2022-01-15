class CarAccessory {
  static const String DB_id_key = "id";
  static const String DB_name_key = "ACSR_NAME";
  static const String DB_arbcName_key = "ACSR_ARBC_NAME";
  static const String DB_value_key = "ACCR_VLUE";
  static const String DB_pivot_key = "pivot";

  int _id;
  String _name;
  String _arbcName;
  String? _value;

  CarAccessory(int id, String name, String arbcName, {String? value})
      : this._id = id,
        this._name = name,
        this._arbcName = arbcName,
        this._value = value;

  CarAccessory.fromJson(Map<String, dynamic> json)
      : this._id = json[DB_id_key],
        this._name = json[DB_name_key],
        this._arbcName = json[DB_arbcName_key],
        this._value = json[DB_pivot_key][DB_value_key] ?? null;

  int get id => _id;
  String get name => _name;
  String get arbcName => _arbcName;
  String? get value => _value;
}
