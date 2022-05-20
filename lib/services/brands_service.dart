import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/main.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BrandsService {
  static final ServerHandler _server = getIt.get<ServerHandler>();

  static Future<ApiResponse<List<Brand>?>> getBrands(BuildContext context) async {
    var request = await http.get(_server.allBrandsURI, headers: _server.headers);
    if (request.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(request.bodyBytes));
      if (decoded["status"] == true &&
          decoded.containsKey("body") &&
          decoded["body"] is Map<String, dynamic> &&
          decoded["body"].containsKey("brands") &&
          decoded["body"]["brands"] is List<dynamic>) {
        List<Brand> brands = [];
        decoded["body"]["brands"].forEach((e) {
          brands.add(new Brand.fromJson(e));
        });
        return new ApiResponse(true, brands, "Tmam");
      } else {
        print(request);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      print("hna:" + request.toString());
      return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }
}
