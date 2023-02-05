import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/models/offers/offer.dart';
import 'package:revmo/models/offers/offer_request.dart';

import '../environment/network_layer.dart';
import '../shared/theme.dart';

class OffersService {
  static final ServerHandler _server = getIt.get<ServerHandler>();

  //Pending Requests////////////////////////////////
  Future<http.Response> extendOffer(int id) async {
    return http.post(_server.extendOffer,
        headers: _server.headers, body: {"offerID": id.toString()});
  }

  Future<http.Response> extendAllOffers() async {
    return http.post(
      _server.extendAllOffers,
      headers: _server.headers,
    );
  }

////////////////////////////////////////////////////
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> networkLayerSubmitOffer(
      int requestID,
      double price,
      double downPayment,
      bool isLoan,
      String startDate,
      String expiryDate,
   Map<String,String> options,
  List<int> colorIDs,
      [String? comment]) {
    return _networkLayer.authDio.post('/api/seller/submit/offer',   data: {
      "requestID": requestID.toString(),
      "price": price.toString(),
      "downPayment": downPayment.toString(),
      "isLoan": isLoan ? '0' : '1',
      "startDate": startDate,
      "expiryDate": expiryDate,
      "options":options,
      "colors": colorIDs,
      "comment": comment ?? null
    });
  }

Future<Response> networkLayerGetPendingOffers(){
    return _networkLayer.authDio.get("/api/seller/offers/pending");
}



  static Future<ApiResponse<Offer>> submitNewOffer(
      BuildContext context,
      int requestID,
      double price,
      double downPayment,
      bool isLoan,
      String startDate,
      String expiryDate,
      List<int> colorIDs,
      [String? comment]) async {
    print("condition 1");
    var request = await http.post(_server.submitOfferURI,
        headers: _server.headers,
        body: {
          "requestID": requestID.toString(),
          "price": price.toString(),
          "downPayment": downPayment.toString(),
          "isLoan": isLoan ? '0' : '1',
          "startDate": startDate,
          "expiryDate": expiryDate,
          // "options": {11: 4, 3: 1, 2: 1, 6: 3, 15: 7, 4: 2, 5: 2, 13: 5},
          "comment": comment ?? null
        }..addAll(_parseColorIDsJsonArray(colorIDs)));
    print("condition 2");

    var decoded = jsonDecode(request.body);
    print("condition 3");

    print(decoded);

    if (request.statusCode == 200 && decoded["status"] == true) {
      print('condition 1');
      print(request.body);
      // print(
      //     '--data ${requestID.toString() + '--Price : \n' + price.toString() + '--DownPayment :\n' + downPayment.toString() + '--isLoan :\n' + isLoan.toString() + '--\n' + startDate + '--\n' + expiryDate + '--\n' + comment!}');
      if (_checkOfferResponse(decoded)) {
        print('condition 2');

        return ApiResponse(
            true, Offer.fromJson(decoded["body"]["offer"]), "success");
      }
    } else {
      print('condition 3');

      RevmoTheme.showRevmoSnackbar(context, request.body);
      print(request.body);
    }
    print('condition 4');

    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<List<OfferRequest>?>> getAvailableOfferRequests(
      BuildContext context) async {
    var request =
        await http.get(_server.offerRequestsURI, headers: _server.headers);
    if (request.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(request.bodyBytes));
      if (_checkOfferRequestsResponse(decoded)) {
        List<OfferRequest> requests = [];
        decoded["body"]["requests"].forEach((e) {
          requests.add(new OfferRequest.fromJson(e));
        });
        return new ApiResponse(true, requests, "Tmam");
      } else {
        print(request);
        return ApiResponse(
            false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      print("hna:" + request.toString());
      return ApiResponse(
          false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Future<ApiResponse<List<Offer>?>> getPendingOffers(
      BuildContext context) async {
    return _getOffers(context, _server.pendingOffersURI);
  }

  static Future<ApiResponse<List<Offer>?>> getApprovedOffers(
      BuildContext context) async {
    return _getOffers(context, _server.approvedOffersURI);
  }

  static Future<ApiResponse<List<Offer>?>> getExpiredOffers(
      BuildContext context) async {
    return _getOffers(context, _server.expiredOffersURI);
  }

  static Future<ApiResponse<List<Offer>?>> _getOffers(
      BuildContext context, Uri offersTypeUri) async {
    var request = await http.get(offersTypeUri, headers: _server.headers);
    if (request.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(request.bodyBytes));
      if (_checkOffersResponse(decoded)) {
        List<Offer> offers = [];
        decoded["body"]["offers"].forEach((e) {
          offers.add(new Offer.fromJson(e));
        });
        return new ApiResponse(true, offers, "Tmam");
      } else {
        print(request);
        return ApiResponse(
            false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      print("hna:" + request.toString());
      return ApiResponse(
          false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Map<String, String> _parseColorIDsJsonArray(List<int> _colorsList) {
    int i = 0;
    Map<String, String> ret = new Map<String, String>();
    _colorsList.forEach(
        (color) => ret["colors"] = color.toString());
    return ret;
  }

  static bool _checkOfferResponse(decoded) =>
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"] is Map<String, dynamic> &&
      decoded["body"].containsKey("offer") &&
      decoded["body"]["offer"] is Map<String, dynamic>;

  static bool _checkOfferRequestsResponse(decoded) =>
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"] is Map<String, dynamic> &&
      decoded["body"].containsKey("requests") &&
      decoded["body"]["requests"] is List<dynamic>;

  static bool _checkOffersResponse(decoded) =>
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"] is Map<String, dynamic> &&
      decoded["body"].containsKey("offers") &&
      decoded["body"]["offers"] is List<dynamic>;
}
