import 'package:dio/dio.dart';
import '../environment/network_layer.dart';



class SubscriptionService {
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> getSubscriptionPlans() {
    return  _networkLayer.authDio.get('/api/seller/plans');
  }



}