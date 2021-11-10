import 'package:revmo/environment/file_service.dart';
import 'package:revmo/environment/key_saver.dart';

class ServerHandler {
  static const _apiTokenKey = "API_TOKEN";
  static final ServerHandler _server = new ServerHandler._singleton();
  late final KeySaver saver;
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

  static const String _loginURL = "seller/login";
  static const String _userURL = "user";
  static const String _registerURL = "seller/register";
  static const String _getCatalogURL = "get/catalog";
  static const String _getCarPoolURL = "get/carpool";
  static const String _setBrandsURL = "set/brands";
  static const String _getBrandsURL = "get/brands";

  //Handle API Token
  Future<bool> setToken(String token) {
    _token = token;
    _headers["Authorization"] = "Bearer $token";
    return saver.save(_apiTokenKey, token);
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

  Uri get userURI {
    return new Uri.https(_address, _sellerApiPrefix + _userURL);
  }

  Uri get catalogURI {
    return new Uri.https(_address, _sellerApiPrefix + _getCatalogURL);
  }

  Uri get carpoolURI {
    return new Uri.https(_address, _sellerApiPrefix + _getCarPoolURL);
  }
}
