import 'package:dio/dio.dart';
import '../environment/network_layer.dart';
import '../environment/server.dart';
import '../main.dart';

class FcmToken {
  static final ServerHandler _server = getIt.get<ServerHandler>();

  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> setToken(String token){

    return    _networkLayer.authDio.post('/api/seller/notifications/settoken',data: {
      "token" : token
    });

  }


}