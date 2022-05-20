class CarType {
  static const API_id_Key = "id";
  static const API_name_Key = "TYPE_NAME";
  static const API_arbcName_Key = "TYPE_ARBC_NAME";

  int _id;
  String _name;
  String _arbcName;

  int get id => _id;
  String get name => _name;
  String get arbcName => _arbcName;

  CarType(this._id, this._name, this._arbcName);

  CarType.fromJson(Map<String, dynamic> json)
      : _id = json[API_id_Key],
        _name = json[API_name_Key],
        _arbcName = json[API_arbcName_Key];
}
