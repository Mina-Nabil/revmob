import 'package:revmo/environment/api_response.dart';
import 'package:revmo/environment/server.dart';
import 'package:revmo/models/catalog.dart';
import 'package:revmo/models/seller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CatalogService {
  static final ServerHandler _server = new ServerHandler();

  Future<ApiResponse<Catalog?>> getSellerCatalog() async {
    return Future.value(ApiResponse(false, null, "aa"));
  }
}
