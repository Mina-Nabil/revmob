import 'package:dio/dio.dart';
import 'package:revmo/environment/network_layer.dart';

class CalendarServices {
  NetworkLayer _service = NetworkLayer();

  Future<Response> getEvents(int id) {
    return _service.authDio.get("/api/seller/offers/$id/events");
  }

  Future<Response> deleteEvents(int id) {
    return _service.authDio.delete("/api/seller/calendar/$id");
  }

  Future<Response> createEvents(
      String title,
      int buyerId,
      int showRoomId,
      int offerId,
      String startDate,
      String endDate,
      String note,
      String location,
      String notificationTime,
    ) {
    return _service.authDio.post("/api/seller/calendar", data: {
      "title":title,
      "buyer_id": buyerId,
      "showroom_id": showRoomId,
      "offer_id": offerId,
      "start": startDate,
      "end": endDate,
      "note": note,
      "location": location,
      "notification_time": notificationTime,
    });
  }
}
