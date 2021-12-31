import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/models/catalog.dart';
import 'package:revmo/models/model_color.dart';
import 'package:revmo/models/offer_defaults.dart';
import 'package:revmo/models/seller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CatalogService {
  static final ServerHandler _server = new ServerHandler();

  Future<ApiResponse<Catalog?>> getSellerCatalog(BuildContext context) async {
    var request = await http.get(_server.catalogURI, headers: _server.headers);
    if (request.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(request.bodyBytes));
      if (decoded["status"] == true &&
          decoded.containsKey("body") &&
          decoded["body"] is Map<String, dynamic> &&
          decoded["body"].containsKey("catalog") &&
          decoded["body"]["catalog"] is Iterable<dynamic>) {
        Catalog catalog = new Catalog();
        try {
          decoded["body"]["catalog"].forEach((catalogEntry) {
            Car tmpCar = Car.fromJson(catalogEntry["car"]);
            OfferDefaults tmpDefaults = OfferDefaults.fromJson(catalogEntry);
            catalog.addCar(tmpCar);
            catalog.setOfferDefaults(tmpCar, tmpDefaults);
            if (catalogEntry.containsKey("colors") && catalogEntry["colors"] is Iterable<dynamic>) {
              catalogEntry["colors"].forEach((catalogColorJson) {
                ModelColor tmpColor = ModelColor.fromJson(catalogColorJson);
                catalog.addColorToCar(tmpCar, tmpColor);
              });
            }
          });
        } catch (e, stack) {
          print(e.toString());
          print(stack.toString());
          return new ApiResponse<Catalog?>(false, null, "Tmaaam");
        }
        return new ApiResponse<Catalog?>(true, catalog, "Tmaaam");
      } else {
        print(request);
      }
    } else {
      print("hna:" + request.toString());
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  Future<ApiResponse<Catalog?>> addToSellerCatalog() async {
    return Future.value(ApiResponse(false, null, "aa"));
  }
}
