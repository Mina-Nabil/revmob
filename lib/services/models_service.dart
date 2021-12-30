import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/models/model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModelsService {
  static ServerHandler _server = new ServerHandler();

  static Future<ApiResponse<List<CarModel>?>> getModels(BuildContext context, int brandID, bool loadCars) async {
    var request = await http.get(_server.getBrandModelsURI(brandID), headers: _server.headers);
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (decoded is Map<String, dynamic> &&
            decoded.containsKey("status") &&
            decoded["status"] == true &&
            decoded.containsKey("body") &&
            decoded["body"] is Iterable<dynamic>) {
          List<CarModel> models = [];
          decoded["body"].forEach((e) {
            try {
              models.add(CarModel.fromJson(e, loadCars: loadCars));
            } catch (e) {
              print(e);
              print(decoded["body"].runtimeType);
            }
          });
          return new ApiResponse<List<CarModel>?>(true, models, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }
}
