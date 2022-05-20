import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/main.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/providers/account_provider.dart';

class AuthService {
  static final ServerHandler server = getIt.get<ServerHandler>();

  static Future<bool> _isLoggedIn() async {
    try {
      String? token = await server.token;
      if (token == null) {
        return false;
      }
      server.setApiToken(token);
      return true;
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  static Future<ApiResponse<Seller?>> getCurrentUser(context) async {
    if (!(await _isLoggedIn())) {
      return new ApiResponse(false, null, "Not LoggedIn!");
    }
    final request = await http.get(server.userURI, headers: server.headers);
    if (request.statusCode == 200) {
      try {
        Map<String, dynamic> decoded = jsonDecode(utf8.decode(request.bodyBytes));
        if (decoded["status"] == true &&
            decoded.containsKey("body") &&
            decoded["body"] is Map<String, dynamic> &&
            decoded["body"].containsKey("user")) {
          return new ApiResponse(
              true, new Seller.fromJson(decoded["body"]["user"], inTeam: true), AppLocalizations.of(context)!.loggedInMsg);
        } else {
          return new ApiResponse(false, null, decoded["message"], errors: decoded["body"]["errors"] ?? null);
        }
      } catch (e, stack) {
        print(e.toString());
        print(stack);
        return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      print(request.body);
      return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Future<ApiResponse<Seller?>> registerSeller(context,
      {required String name,
      required String email,
      required String mobNumber,
      required String password,
      File? displayImage}) async {
    var request = http.MultipartRequest(
      "POST",
      server.registrationURI,
    )
      ..fields.addAll({
        Seller.FORM_NAME_Key: name,
        Seller.FORM_EMAIL_Key: email,
        Seller.FORM_MOB_Key: mobNumber,
        Seller.FORM_PW_Key: password,
        "deviceName": await server.deviceName
      })
      ..headers.addAll(server.headers);

    if (displayImage != null) {
      var pic = await http.MultipartFile.fromPath(
        'displayImage',
        displayImage.path,
      );
      request.files.add(pic);
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      try {
        print(response.stream.toString());
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        dynamic decoded = jsonDecode(responseString);
        if (decoded["status"] == true) {
          Seller newSeller = Seller.fromJson(decoded["body"]["seller"]);
          await server.setApiToken(decoded["body"]["token"]); //userloggedIn
          return new ApiResponse<Seller>(true, newSeller, AppLocalizations.of(context)!.sellerCreatedMsg);
        } else {
          return new ApiResponse(false, null, decoded["message"], errors: decoded["body"]["errors"] ?? null);
        }
      } catch (e, stack) {
        print(e.toString());
        print(stack);
        return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      print(response.stream.toString());
      return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Future<ApiResponse<Seller?>> login(context, {required String identifier, required String password}) async {
    var response = await http.post(server.loginURI,
        headers: server.headers,
        body: {Seller.FORM_IDENTIFIER_Key: identifier, Seller.FORM_PW_Key: password, "deviceName": await server.deviceName});

    if (response.statusCode == 200) {
      try {
        dynamic decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded["status"] == true &&
            decoded.containsKey("body") &&
            decoded["body"] is Map<String, dynamic> &&
            decoded["body"].containsKey("apiKey") &&
            decoded["body"].containsKey("seller")) {
          Seller newSeller = Seller.fromJson(decoded["body"]["seller"]);
          server.setApiToken(decoded["body"]["apiKey"]);
          return new ApiResponse<Seller>(true, newSeller, AppLocalizations.of(context)!.loggedInMsg);
        } else {
          return new ApiResponse(false, null, AppLocalizations.of(context)!.cantLogin,
              errors: (decoded["body"] is Map<String, String> && decoded["body"].containsKey("errors"))
                  ? decoded["body"]["errors"]
                  : null);
        }
      } catch (e, stack) {
        print(e.toString());
        print(stack);
        return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Future<ApiResponse<bool>> isEmailTaken(context, email) async {
    final request = await http.post(server.checkEmailURI, headers: server.headers, body: {
      Seller.FORM_EMAIL_Key: email,
    });
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(request.body);

        return ApiResponse<bool>(decoded["status"], decoded["body"], AppLocalizations.of(context)!.serverIssue);
      } catch (e) {
        print(e);
        return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Future<ApiResponse<bool>> isPhoneTaken(context, phone) async {
    final request = await http.post(server.checkPhoneURI, headers: server.headers, body: {
      "phone": phone,
    });
    if (request.statusCode == 200) {
      try {
        var decoded = jsonDecode(request.body);

        return ApiResponse<bool>(decoded["status"], decoded["body"], AppLocalizations.of(context)!.serverIssue);
      } catch (e) {
        print(e);
        return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      return ApiResponse(false, false, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Future<bool> logOut(context) async {
    bool tokenDeleted = await server.deleteApiToken();
    bool providerUserDeleted = true;
    try {
      Provider.of<AccountProvider>(context, listen: false).clearUser();
    } catch (e) {
      print(e);
      providerUserDeleted = false;
    }
    return providerUserDeleted && tokenDeleted;
  }
}
