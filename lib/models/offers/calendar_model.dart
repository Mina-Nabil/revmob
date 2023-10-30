class CalendarModel {
  int id;
  int sellerId;
  String title;
  DateTime start;
  DateTime end;
  int buyerId;
  int showroomId;
  int offerId;
  String note;
  String location;
  DateTime? notificationTime;
  DateTime createdAt;
  DateTime updatedAt;

  CalendarModel({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.start,
    required this.end,
    required this.buyerId,
    required this.showroomId,
    required this.offerId,
    required this.note,
    required this.location,
     this.notificationTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) => CalendarModel(
    id: json["id"],
    sellerId: json["seller_id"],
    title: json["title"],
    start: DateTime.parse(json["start"]),
    end: DateTime.parse(json["end"]),
    buyerId: json["buyer_id"],
    showroomId: json["showroom_id"],
    offerId: json["offer_id"],
    note: json["note"],
    location: json["location"],
    notificationTime: DateTime.parse(json["notification_time"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "seller_id": sellerId,
    "title": title,
    "start": start.toIso8601String(),
    "end": end.toIso8601String(),
    "buyer_id": buyerId,
    "showroom_id": showroomId,
    "offer_id": offerId,
    "note": note,
    "location": location,
    // "notification_time": notificationTime.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}