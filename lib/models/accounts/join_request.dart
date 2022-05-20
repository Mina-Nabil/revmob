import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/models/accounts/showroom.dart';

enum JoinRequestStatus { InvitedByShowroom, RequestedBySeller, Accepted }

class JoinRequest {
  static const String API_id_Key = "id";
  static const String API_showroom_Key = "showroom";
  static const String API_seller_Key = "seller";
  static const String API_status_Key = "JNRQ_STTS";

  static const String API_is_invited_VALUE = "Showroom Requested";
  static const String API_is_requesting_VALUE = "Seller Requested";

  int _id;
  Showroom _showroom;
  Seller _seller;
  JoinRequestStatus status;

  JoinRequest.fromJson(json)
      : _showroom = Showroom.fromJson(json[API_showroom_Key]),
        _id = json["id"],
        _seller = Seller.fromJson(json[API_seller_Key]),
        status = json[API_status_Key] == API_is_invited_VALUE
            ? JoinRequestStatus.InvitedByShowroom
            : json[API_status_Key] == API_is_requesting_VALUE
                ? JoinRequestStatus.RequestedBySeller
                : JoinRequestStatus.Accepted {
    _seller.requestedStatus = status;
    _showroom.requestedStatus = status;
  }

  int get id => _id;
  Showroom get showroom => _showroom;
  Seller get seller => _seller;
}
