class Plans {
  int? id;
  String? name;
  int? monthlyPrice;
  int? annualPrice;
  int? adminsLimit;
  int? usersLimit;
  int? modelsLimit;
  int? offersLimit;
  int? servicesLimit;
  int? facilityPayment;
  int? emailSupport;
  int? chatSupport;
  int? phoneSupport;
  int? dashboardAccess;
  int? order;
  bool? selected = false;

  Plans(
      {this.id,
        this.name,
        this.monthlyPrice,
        this.annualPrice,
        this.adminsLimit,
        this.usersLimit,
        this.modelsLimit,
        this.offersLimit,
        this.servicesLimit,
        this.facilityPayment,
        this.emailSupport,
        this.chatSupport,
        this.phoneSupport,
        this.dashboardAccess,
        this.order});

  Plans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    monthlyPrice = json['monthly_price'];
    annualPrice = json['annual_price'];
    adminsLimit = json['admins_limit'];
    usersLimit = json['users_limit'];
    modelsLimit = json['models_limit'];
    offersLimit = json['offers_limit'];
    servicesLimit = json['services_limit'];
    facilityPayment = json['facility_payment'];
    emailSupport = json['email_support'];
    chatSupport = json['chat_support'];
    phoneSupport = json['phone_support'];
    dashboardAccess = json['dashboard_access'];
    order = json['order'];
  }

}

class CurrentPlan {
  int? users;
  int? admins;
  int? offers;
  int? models;
  CurrentPlan({this.users, this.admins, this.offers, this.models});

  CurrentPlan.fromJson(Map<String, dynamic> json) {
    users = json['users'];
    admins = json['admins'];
    offers = json['offers'];
    models = json['models'];
  }


}


class Subscription {
  int? planId;
  String? state;
  String? type;
  String? expiryDate;
  int? sellerId;
  String? range;
  int? showroomId;
  String? updatedAt;
  String? createdAt;
  int? id;
  Plans? plan;

  Subscription(
      {this.planId,
        this.state,
        this.type,
        this.expiryDate,
        this.sellerId,
        this.range,
        this.showroomId,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.plan});

  Subscription.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    state = json['state'];
    type = json['type'];
    expiryDate = json['expiry_date'];
    sellerId = json['seller_id'];
    range = json['range'];
    showroomId = json['showroom_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    plan = json['plan'] != null ? new Plans.fromJson(json['plan']) : null;
  }


}