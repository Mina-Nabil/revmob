import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/main.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/showroom.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/services/fcm_token.dart';

class AccountService {
  static final ServerHandler _server = getIt.get<ServerHandler>();
  //Team Handling Functions
  static Future<ApiResponse<List<Seller>?>> getShowroomTeam(BuildContext context, {Showroom? loadedShowroom}) async {
    var request = await http.get(_server.teamUri, headers: _server.headers);
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkTeamResponse(decoded)) {
          List<Seller> team = [];
          decoded["body"]["team"].forEach((e) {
            try {
              team.add(Seller.fromJson(e, inTeam: true, loadedShowroom: loadedShowroom));
            } catch (e, stack) {
              print(e);
              print(stack);
            }
          });
          return new ApiResponse<List<Seller>?>(true, team, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<List<JoinRequest>?>> getShowromJoinRequestsAndInvitations(BuildContext context) async {
    var request = await http.get(_server.showroomInvitationsURI, headers: _server.headers);
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkRequestsResponse(decoded)) {
          List<JoinRequest> requests = [];
          decoded["body"]["requests"].forEach((e) {
            try {
              requests.add(JoinRequest.fromJson(e));
            } catch (e, stack) {
              print(e);
              print(stack);
            }
          });
          return new ApiResponse<List<JoinRequest>?>(true, requests, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<List<Seller>?>> searchSellers(BuildContext context, String searchText) async {
    var request = await http.post(_server.sellersSearchURI, headers: _server.headers, body: {"searchText": searchText});
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkSellersSearchResponse(decoded)) {
          List<Seller> sellers = [];
          decoded["body"]["sellers"].forEach((e) {
            try {
              sellers.add(Seller.fromJson(e));
            } catch (e, stack) {
              print(e);
              print(stack);
            }
          });
          return new ApiResponse<List<Seller>?>(true, sellers, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<List<JoinRequest>?>> getSellerInvitationsAndRequests(BuildContext context) async {
    var request = await http.get(_server.joinRequestsURI, headers: _server.headers);
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkRequestsResponse(decoded)) {
          List<JoinRequest> requests = [];
          decoded["body"]["requests"].forEach((e) {
            try {
              requests.add(JoinRequest.fromJson(e));
            } catch (e, stack) {
              print(e);
              print(stack);
            }
          });
          return new ApiResponse<List<JoinRequest>?>(true, requests, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<List<Showroom>?>> searchShowrooms(BuildContext context, String searchText) async {
    var request = await http.post(_server.showroomSearchURI, headers: _server.headers, body: {"searchText": searchText});
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkShowroomSearchResponse(decoded)) {
          List<Showroom> showrooms = [];
          decoded["body"]["showrooms"].forEach((e) {
            try {
              showrooms.add(Showroom.fromJson(e));
            } catch (e, stack) {
              print(e);
              print(stack);
            }
          });
          return new ApiResponse<List<Showroom>?>(true, showrooms, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<JoinRequest?>> sendSellerInvitation(BuildContext context, int sellerID) async {
    var request = await http.post(_server.sendInvitationURI, headers: _server.headers, body: {"sellerID": sellerID.toString()});
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkSingleRequestResponse(decoded)) {
          return new ApiResponse<JoinRequest?>(true, JoinRequest.fromJson(decoded["body"]["request"]), "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<JoinRequest?>> sendShowroomJoinRequest(BuildContext context, int showroomID) async {
    var request = await http.post(_server.sendJoinRequestURI, headers: _server.headers, body: {"showroomID": showroomID.toString()});
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkSingleRequestResponse(decoded)) {
          return new ApiResponse<JoinRequest>(true, JoinRequest.fromJson(decoded["body"]["request"]), "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<bool>> acceptRequest(BuildContext context, int joinRequestID) async {
    var request = await http.post(_server.acceptRequestURI, headers: _server.headers, body: {"joinRequestID": joinRequestID.toString()});
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkManagementFunctionsResponse(decoded)) {
          return new ApiResponse<bool>(true, true, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
  }

  static Future<ApiResponse<bool>> acceptInvitation(BuildContext context, int joinRequestID) async {
    var request =
        await http.post(_server.acceptInvitationURI, headers: _server.headers, body: {"joinRequestID": joinRequestID.toString()});
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkManagementFunctionsResponse(decoded)) {
          return new ApiResponse<bool>(true, true, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
  }




  static Future<ApiResponse<bool>> deleteRequest(BuildContext context, int joinRequestID) async {
    var request = await http.delete(_server.deleteRequestURI,
        headers: _server.headers, body: {"joinRequestID": joinRequestID.toString()});
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (_checkManagementFunctionsResponse(decoded)) {
          return new ApiResponse<bool>(true, true, "Tmam");
        }
      } catch (e) {
        print(e);
        return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
      }
    }
    return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
  }

  static bool _checkTeamResponse(decoded) =>
      decoded is Map<String, dynamic> &&
      decoded.containsKey("status") &&
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"].containsKey("team") &&
      decoded["body"]["team"] is Iterable<dynamic>;

  static bool _checkSellersSearchResponse(decoded) =>
      decoded is Map<String, dynamic> &&
      decoded.containsKey("status") &&
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"].containsKey("sellers") &&
      decoded["body"]["sellers"] is Iterable<dynamic>;

  static bool _checkShowroomSearchResponse(decoded) =>
      decoded is Map<String, dynamic> &&
      decoded.containsKey("status") &&
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"].containsKey("showrooms") &&
      decoded["body"]["showrooms"] is Iterable<dynamic>;

  static bool _checkRequestsResponse(decoded) =>
      decoded is Map<String, dynamic> &&
      decoded.containsKey("status") &&
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"].containsKey("requests") &&
      decoded["body"]["requests"] is Iterable<dynamic> ;

  static bool _checkSingleRequestResponse(decoded) =>
      decoded is Map<String, dynamic> &&
      decoded.containsKey("status") &&
      decoded["status"] == true &&
      decoded.containsKey("body") &&
      decoded["body"].containsKey("request") &&
      decoded["body"]["request"] is Map<String, dynamic> ;

  static bool _checkManagementFunctionsResponse(decoded) =>
      decoded is Map<String, dynamic> && decoded.containsKey("status") && decoded["status"] == true;
}
