class Extras {
  int id;
  int ofxtOffrId;
  String title;
  String imageUrl;
  String price;
  String note;
  DateTime createdAt;
  DateTime updatedAt;
  String fullUrl;

  Extras({
    required this.id,
    required this.ofxtOffrId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.fullUrl,
  });

  factory Extras.fromJson(Map<String, dynamic> json) => Extras(
    id: json["id"],
    ofxtOffrId: json["OFXT_OFFR_ID"],
    title: json["title"],
    imageUrl: json["image_url"],
    price: json["price"],
    note: json["note"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    fullUrl: json["full_url"],
  );

}