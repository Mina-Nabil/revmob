import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/models/cars/showroom.dart';

class SellerProfileService {
  static final ServerHandler server = new ServerHandler();

  static Future<ApiResponse<Showroom?>> createShowroom(
    context, {
    required String name,
    required String email,
    required String mobNumber,
    required String address,
    required int cityID,
    File? image,
  }) async {
    var request = http.MultipartRequest("POST", server.createShowroom);
    request.fields[Showroom.FORM_NAME_KEY] = name;
    request.fields[Showroom.FORM_EMAIL_KEY] = email;
    request.fields[Showroom.FORM_MOB_KEY] = mobNumber;
    request.fields[Showroom.FORM_ADRS_KEY] = address;
    request.fields[Showroom.FORM_CITY_KEY] = cityID.toString();

    if (image != null) {
      var pic = await http.MultipartFile.fromPath(
        'displayImage',
        image.path,
      );
      request.files.add(pic);
    }
    request.headers.addAll(server.headers);
    var response = await request.send();
    try {
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        dynamic decodedResponse = jsonDecode(responseString);

        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse["status"] == true &&
            decodedResponse.containsKey("body") &&
            decodedResponse["body"] is Map<String, dynamic> &&
            decodedResponse["body"].containsKey("showroom")) {
          return new ApiResponse<Showroom>(
              true, new Showroom.fromJson(decodedResponse["body"]["showroom"]), AppLocalizations.of(context)!.showroomCreatedMsg);
        } else {
          return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue,
              errors: decodedResponse["body"]["errors"] ?? null);
        }
      } else {
        return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      return new ApiResponse(false, null, AppLocalizations.of(context)!.serverIssue);
    }
  }

  static Future<ApiResponse<bool>> setBankInfo(BuildContext context,
      {required String accountbankName,
      required String accountNumber,
      required String accountHolderName,
      required String iban}) async {
    final request = await http.post(server.bankInfoURI, headers: server.headers);
    if (request.statusCode == 200) {
      try {
        Map<String, dynamic> decoded = jsonDecode(utf8.decode(request.bodyBytes));
        return new ApiResponse<bool>(decoded["status"], decoded["status"],
            decoded["status"] ? AppLocalizations.of(context)!.setBankMsg : AppLocalizations.of(context)!.serverIssue,
            errors: (decoded["body"].containsKey("errors")) ? decoded["body"]["errors"] ?? null : null);
      } catch (e, stack) {
        print(e.toString());
        print(stack);
        return new ApiResponse<bool>(false, false, AppLocalizations.of(context)!.serverIssue);
      }
    } else {
      print(request.body);
      return new ApiResponse<bool>(false, false, AppLocalizations.of(context)!.serverIssue);
    }
  }
}
