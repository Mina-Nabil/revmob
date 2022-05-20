class CarAccessory {
  static const String API_id_Key = "id";
  static const String API_name_Key = "ACSR_NAME";
  static const String API_arbcName_Key = "ACSR_ARBC_NAME";
  static const String API_value_Key = "ACCR_VLUE";
  static const String API_pivot_Key = "pivot";

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
      : this._id = json[API_id_Key],
        this._name = json[API_name_Key],
        this._arbcName = json[API_arbcName_Key],
        this._value = json[API_pivot_Key][API_value_Key] ?? null;

  int get id => _id;
  String get name => _name;
  String get arbcName => _arbcName;
  String? get value => _value;
}
