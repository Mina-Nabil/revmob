import 'package:dio/dio.dart';

import '../../../environment/network_layer.dart';

class CalendarDetailServices {
  // /api/seller/calendar/2
  NetworkLayer _service = NetworkLayer();

  Future<Response> deleteEvent(int id) {
    return _service.authDio.delete("/api/seller/calendar/$id");
  }

  Future<Response> editEvent(
    String title,
    String startDate,
    String endDate,
    String note,
    String location,
    String notificationTime,
      int id
  ) {
    return _service.authDio.post("/api/seller/calendar/$id", data: {
      "title": title,
      "start": startDate,
      "end": endDate,
      "note": note,
      "location": location,
      "notification_time": notificationTime,
    });
  }
}
