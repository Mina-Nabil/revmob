class Docs {
  int id;
  int ofdcOffrId;
  String title;
  String? docUrl;
  String? fullUrl;
  String? note;
  int isSeller;
  DateTime createdAt;
  DateTime updatedAt;

  Docs({
    required this.id,
    required this.ofdcOffrId,
    required this.title,
    this.docUrl,
    this.fullUrl,
    this.note,
    required this.isSeller,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Docs.fromJson(Map<String, dynamic> json) => Docs(
    id: json["id"],
    ofdcOffrId: json["OFDC_OFFR_ID"],
    title: json["title"],
    docUrl: json["doc_url"],
    fullUrl: json["full_url"],
    note: json["note"],
    isSeller: json["is_seller"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "OFDC_OFFR_ID": ofdcOffrId,
    "title": title,
    "doc_url": docUrl,
    "note": note,
    "is_seller": isSeller,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}