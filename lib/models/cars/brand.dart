class Brand {
  static const String DB_id_KEY = "id";
  static const String DB_name_KEY = "BRND_NAME";
  static const String DB_logoUrl_KEY = "logo_url";
  static const String DB_arbcName_KEY = "BRND_ARBC_NAME";

  final int id;
  final String name;
  final String arbcName;
  final String logoURL;

  Brand(this.id, this.name, this.arbcName, this.logoURL);

  Brand.fromJson(Map<String, dynamic> json)
      : id = json[DB_id_KEY],
        name = json[DB_name_KEY],
        arbcName = json[DB_arbcName_KEY],
        logoURL = json[DB_logoUrl_KEY];

  operator ==(o) => o is Brand && id == o.id;

  @override
  String toString() => name;

  @override
  int get hashCode => id.hashCode;
}
