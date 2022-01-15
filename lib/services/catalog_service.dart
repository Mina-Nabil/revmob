import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/models/catalog.dart';
import 'package:revmo/models/model_color.dart';
import 'package:revmo/models/offer_defaults.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CatalogService {
  static final ServerHandler _server = new ServerHandler();

  Future<ApiResponse<Catalog?>> getSellerCatalog(BuildContext context) async {
    var request = await http.get(_server.catalogURI, headers: _server.headers);
    if (request.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(request.bodyBytes));
      if (_validateCatalogResponse(decoded)) {
        Catalog catalog = new Catalog();
        try {
          catalog = _parseCatalog(decoded);
          return new ApiResponse<Catalog?>(true, catalog, "Tmaaam");
        } catch (e) {
          return new ApiResponse<Catalog?>(false, null, "Tmaaam");
        }
      } else {
        print(request);
      }
    } else {
      print("hna:" + request.toString());
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  Future<ApiResponse<Catalog?>> addToSellerCatalog(BuildContext context, Catalog catalog) async {
    var request = await http
        .post(_server.addCarsToCatalogURI, headers: _server.headers, body: _parseAddForm(catalog))
        .timeout(Duration(seconds: 5));
    if (request.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(request.bodyBytes));
      if (_validateCatalogResponse(decoded)) {
        try {
          catalog = _parseCatalog(decoded);
          return new ApiResponse<Catalog?>(true, catalog, "Tmaaam");
        } catch (e, stack) {
          print(e.toString());
          print(stack.toString());
          return new ApiResponse<Catalog?>(false, null, "Tmaaam");
        }
      } else {
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  Future<ApiResponse<bool?>> removeCar(BuildContext context, Car car) async {
    var request = await http
        .delete(_server.removeCarCatalogURI, headers: _server.headers, body: {"carID": car.id.toString()}).timeout(Duration(seconds: 5));
    if (request.statusCode == 200) {
      Map<String, dynamic> decoded = jsonDecode(request.body);
      if (decoded.containsKey("status") && decoded["status"] == true) {
        return ApiResponse(true, true, "Tmam");
      } else
        return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
    } else {
      return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  bool _validateCatalogResponse(Map<String, dynamic> decoded) {
    return decoded["status"] == true &&
        decoded.containsKey("body") &&
        decoded["body"] is Map<String, dynamic> &&
        decoded["body"].containsKey("catalog") &&
        decoded["body"]["catalog"] is Iterable<dynamic>;
  }

  Catalog _parseCatalog(Map<String, dynamic> decoded) {
    Catalog tmp = new Catalog();
    decoded["body"]["catalog"].forEach((catalogEntry) {
      Car tmpCar = Car.fromJson(catalogEntry["car"]);
      OfferDefaults tmpDefaults = OfferDefaults.fromJson(catalogEntry);
      tmp.addCar(tmpCar);
      tmp.setOfferDefaults(tmpCar, tmpDefaults);
      if (catalogEntry.containsKey("colors") && catalogEntry["colors"] is Iterable<dynamic>) {
        catalogEntry["colors"].forEach((catalogColorJson) {
          ModelColor tmpColor = ModelColor.fromJson(catalogColorJson);
          tmp.addColorToCar(tmpCar, tmpColor);
        });
      }
    });

    return tmp;
  }

  Map<String, String> _parseAddForm(Catalog catalog) {
    Map<String, String> ret = new Map<String, String>();
    int i = 0;
    catalog.carIDs.forEach((carID) => ret["carIDs[" + (i++).toString() + "]"] = carID.toString());
    i = 0;
    catalog.fullListOfCars.forEach((car) {
      catalog.getCarColors(car).forEach((color) {
        ret["colors" + car.id.toString() + "[" + (i++).toString() + "]"] = color.id.toString();
      });
    });
    return ret;
  }
}
