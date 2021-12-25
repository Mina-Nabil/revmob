class CarType {
  static const DB_id_KEY = "id";
  static const DB_name_KEY = "TYPE_NAME";
  static const DB_arbcName_KEY = "TYPE_ARBC_NAME";

  int _id;
  String _name;
  String _arbcName;

  int get id => _id;
  String get name => _name;
  String get arbcName => _arbcName;

  CarType(this._id, this._name, this._arbcName);

  CarType.fromJson(Map<String, dynamic> json)
      : _id = json[DB_id_KEY],
        _name = json[DB_name_KEY],
        _arbcName = json[DB_arbcName_KEY];
}
