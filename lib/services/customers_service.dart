import 'package:dio/dio.dart';
import 'package:revmo/main.dart';
import 'package:http/http.dart' as http;
import 'package:revmo/environment/server.dart';

import '../environment/network_layer.dart';



class CustomersService {
  static final ServerHandler _server = getIt.get<ServerHandler>();
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> getCustomersNetworkLayer() {
    return  _networkLayer.authDio.get('/api/seller/customers');
  }

  Future<http.Response> getCustomers(){
    return  http.get(
        Uri.parse('https://revmo.msquare.app/api/seller/customers'),
      headers: _server.headers
    );
  }

}