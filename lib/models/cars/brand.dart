class Brand {
  static const String API_id_Key = "id";
  static const String API_name_Key = "BRND_NAME";
  static const String API_logoUrl_Key = "logo_url";
  static const String API_arbcName_Key = "BRND_ARBC_NAME";

  final int id;
  final String name;
  final String arbcName;
  final String logoURL;

  Brand(this.id, this.name, this.arbcName, this.logoURL);

  Brand.fromJson(Map<String, dynamic> json)
      : id = json[API_id_Key],
        name = json[API_name_Key],
        arbcName = json[API_arbcName_Key],
        logoURL = json[API_logoUrl_Key];

  operator ==(o) => o is Brand && id == o.id;

  @override
  String toString() => name;

  @override
  int get hashCode => id.hashCode;
}
