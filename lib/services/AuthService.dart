import 'dart:convert';

import 'package:revmo/environment/server.dart';
import 'package:revmo/models/seller.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static final ServerHandler server = new ServerHandler();

  static Future<bool> isLoggedIn() async {
    try {
      String? token = await server.token;
      if (token == null) {
        return Future.value(false);
      }
      final request = await http.get(server.userURI, headers: server.headers);
      if (request.statusCode == 200) {
        print(request.body);
        final body = jsonDecode(request.body);
        final ret = body["status"] ?? false;
        if(ret){

        }
        return ret;
      }
      return Future.value(false);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }
}
