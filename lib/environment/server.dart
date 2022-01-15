import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:revmo/environment/file_service.dart';
import 'package:revmo/environment/key_saver.dart';

class ServerHandler {
  static const _apiTokenKey = "API_TOKEN";
  static final ServerHandler _server = new ServerHandler._singleton();
  late final KeySaver saver;
  String? _deviceName;
  String? _token;
  Map<String, String> _headers = Map<String, String>();

  factory ServerHandler() {
    return _server;
  }

  ServerHandler._singleton() {
    saver = FileService();
    _headers["Accept"] = "application/json";
  }

  static const String _address = "revmo.msquare.app";
  static const String _sellerApiPrefix = "api/seller/";

  //profile urls
  static const String _loginURL = "api/seller/login";
  static const String _userURL = "user";
  static const String _checkEmail = "check/email";
  static const String _checkPhone = "check/phone";
  static const String _registerURL = "api/seller/register";
  static const String _createShowroom = "create/showroom";
  static const String _bankURL = "api/seller/set/banking";
  //catalog urls
  static const String _getCatalogURL = "get/catalog";
  static const String _getCarPoolURL = "get/carpool";
  static const String _getAllBrandsURL = "get/all/brands";
  static const String _getModelsByBrand = "get/models/";
  static const String _addCarsToCatalogURL = "add/car";
  static const String _editCarColorsURL = "edit/catalog/{id}";
  static const String _removeCarFromCatalogURL = "remove/car";
  static const String _deactivateCarFromCatalogURL = "deactivate/car";

  //offers urls

  //Handle API Token
  Future<bool> setApiToken(String token) async {
    _token = token;
    _headers["Authorization"] = "Bearer $token";
    return await saver.save(_apiTokenKey, token);
  }

  Future<bool> deleteApiToken() async {
    _token = null;
    _headers.remove("Authorization");
    return await saver.delete(_apiTokenKey);
  }

  Future<String?> get token async {
    if (_token != null)
      return _token;
    else
      return await saver.read(_apiTokenKey);
  }

  Map<String, String> get headers {
    return _headers;
  }

  void setHeader(key, value) {
    _headers[key] = value;
  }

  //URL Getters
  Uri get loginURI {
    return new Uri.https(_address, _loginURL);
  }

  Uri get registrationURI {
    return new Uri.https(_address, _registerURL);
  }

  Uri get checkEmailURI {
    return new Uri.https(_address, _sellerApiPrefix + _checkEmail);
  }

  Uri get checkPhoneURI {
    return new Uri.https(_address, _sellerApiPrefix + _checkPhone);
  }

  Uri get userURI {
    return new Uri.https(_address, _sellerApiPrefix + _userURL);
  }

  Uri get createShowroom {
    return new Uri.https(_address, _sellerApiPrefix + _createShowroom);
  }

  Uri get bankInfoURI {
    return new Uri.https(_address, _sellerApiPrefix + _bankURL);
  }

  Uri get catalogURI {
    return new Uri.https(_address, _sellerApiPrefix + _getCatalogURL);
  }

  Uri get carpoolURI {
    return new Uri.https(_address, _sellerApiPrefix + _getCarPoolURL);
  }

  Uri get allBrandsURI {
    return new Uri.https(_address, _sellerApiPrefix + _getAllBrandsURL);
  }

  Uri getBrandModelsURI(int brandID) {
    return new Uri.https(_address, _sellerApiPrefix + _getModelsByBrand + brandID.toString());
  }

  Uri get addCarsToCatalogURI {
    return new Uri.https(_address, _sellerApiPrefix + _addCarsToCatalogURL);
  }

  Uri get editCarColorsURI {
    return new Uri.https(_address, _sellerApiPrefix + _editCarColorsURL);
  }

  Uri get removeCarCatalogURI {
    return new Uri.https(_address, _sellerApiPrefix + _removeCarFromCatalogURL);
  }

  Uri get deactivateCarCatalogURI {
    return new Uri.https(_address, _sellerApiPrefix + _deactivateCarFromCatalogURL);
  }

  Future<String> get deviceName async {
    if (_deviceName == null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
        return androidInfo.model ?? "no";
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print('Running on ${iosInfo.utsname.machine}');
        return iosInfo.utsname.machine ?? "no";
      }
    } else {
      return Future.value(_deviceName);
    }
  }
}
