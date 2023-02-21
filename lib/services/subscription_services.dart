import 'dart:io';

import 'package:dio/dio.dart';
import '../environment/network_layer.dart';

import 'dart:async';
import 'package:http_parser/http_parser.dart';

class UserServiceNetworkLayer {
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> getSubscriptionPlans() {
    return _networkLayer.authDio.get('/api/seller/plans');
  }

  Future<Response> getCurrentPlan() {
    return _networkLayer.authDio.get('/api/seller/limits');
  }

  Future<Response> editProfile({
    File? image,
    required String username,
    required String mobNumber1,
    required String? mobNumber2,
  })async  {

    if (image != null) {
      String fileName = image.path.split('/').last;
      print(fileName);

      var data = FormData.fromMap({
        'name': username,
        'mobNumber1': mobNumber1,
        'mobNumber2': mobNumber2,
        "displayImage":  await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: MediaType('application', 'x-tar'),
        ),
      });
      return await _networkLayer.authDio.post("/api/seller/user",
          // options:
          // Options(
          //     headers:{
          //       "Authorization" : "Bearer ${Auth.token}"
          //     }
          // ),
          data: data

      );
    }else {
    return _networkLayer.authDio.post("/api/seller/user",  data: {
    'name': username,
    'mobNumber1': mobNumber1,
    "displayImage": null,
    'mobNumber2': mobNumber2,
    },);}
  }
}
