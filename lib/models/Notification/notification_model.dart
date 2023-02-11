class NotificationModel {
  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  DetailsNotification? data;
  String? createdAt;
  String? updatedAt;
  dynamic readAt;
  String? title;
  String? body;
  dynamic route;

  NotificationModel({this.id, this.type, this.notifiableType, this.notifiableId, this.data, this.createdAt, this.updatedAt, this.readAt, this.title, this.body, this.route});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data = json['data'] != null ? new DetailsNotification.fromJson(json['data']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    readAt = json['read_at'];
    title = json['title'];
    body = json['body'];
    route = json['route'];
  }

}

class DetailsNotification {
  String? model;
  String? brand;

  DetailsNotification({this.model, this.brand});

  DetailsNotification.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    brand = json['brand'];
  }


}