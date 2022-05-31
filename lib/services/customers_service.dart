import 'package:http/http.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:revmo/environment/server.dart';



class CustomersService {
  static final ServerHandler _server = getIt.get<ServerHandler>();



  Future<Response> getCustomers(){
    return  http.get(
        Uri.parse('https://revmo.msquare.app/api/seller/customers'),
      headers: _server.headers
    );
  }

}