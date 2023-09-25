import 'dart:io';

import 'package:dio/dio.dart';
import 'package:revmo/environment/network_layer.dart';
import 'package:http_parser/http_parser.dart';

class ExtrasServices {

  NetworkLayer _service=  NetworkLayer();


  Future<Response> getExtras(int id) {

    return _service.authDio.get("/api/seller/offers/$id/extras");
  }

  Future<Response> deleteExtra(int id) {

    return _service.authDio.delete("/api/seller/offers/extra/$id");
  }

  Future<Response> uploadExtra(
      int offerID,
      String title,
      String note,
      String price,

      File image,
      ) async {

      String fileName = image.path.split('/').last;
      print(fileName);

      var data = FormData.fromMap({
        'offer_id': offerID.toString(),
        'title': title,
        'note':note,
        'price':price,
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: MediaType('application', 'x-tar'),
        ),
      });
      return _service.authDio.post('/api/seller/offers/extra', data: data
      );

  }
}