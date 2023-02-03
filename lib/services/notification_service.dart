
import 'package:dio/dio.dart';

import '../environment/network_layer.dart';

class NotificationService {
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> getNotification() {
    return  _networkLayer.authDio.get('/api/seller/notifications');
  }

}