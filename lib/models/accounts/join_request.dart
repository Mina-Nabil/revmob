import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/models/accounts/showroom.dart';

enum JoinRequestStatus { InvitedByShowroom, RequestedBySeller, Accepted }

class JoinRequest {
  static const String DB_id_Key = "id";
  static const String DB_showroom_Key = "showroom";
  static const String DB_seller_Key = "seller";
  static const String DB_status_KEY = "JNRQ_STTS";

  static const String DB_is_invited_VALUE = "Showroom Requested";
  static const String DB_is_requesting_VALUE = "Seller Requested";

  int _id;
  Showroom _showroom;
  Seller _seller;
  JoinRequestStatus status;

  JoinRequest.fromJson(json)
      : _showroom = Showroom.fromJson(json[DB_showroom_Key]),
        _id = json["id"],
        _seller = Seller.fromJson(json[DB_seller_Key]),
        status = json[DB_status_KEY] == DB_is_invited_VALUE
            ? JoinRequestStatus.InvitedByShowroom
            : json[DB_status_KEY] == DB_is_requesting_VALUE
                ? JoinRequestStatus.RequestedBySeller
                : JoinRequestStatus.Accepted {
    _seller.requestedStatus = status;
    _showroom.requestedStatus = status;
  }

  int get id => _id;
  Showroom get showroom => _showroom;
  Seller get seller => _seller;
}
