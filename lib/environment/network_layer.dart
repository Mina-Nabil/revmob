
import 'package:dio/dio.dart';

import '../environment/server.dart';
import '../main.dart';


class NetworkLayer {

  factory NetworkLayer() {
    _this ??= NetworkLayer._();
    return _this!;
  }
  static NetworkLayer? _this;


  static final ServerHandler server = getIt.get<ServerHandler>();
  final String _baseURL = "https://revmo.msquare.app";
  Dio unAuthDio = Dio();
  Dio authDio = Dio();

  NetworkLayer._() {
    unAuthDio.options.baseUrl = _baseURL;
    authDio.options.baseUrl = _baseURL;
    unAuthDio.options.connectTimeout = 6000;
    authDio.options.connectTimeout = 6000;
    initializeInterceptors();
  }


  initializeInterceptors() {
    unAuthDio.interceptors.clear();
    authDio.interceptors.clear();


    unAuthDio.interceptors.add(InterceptorsWrapper(
        onRequest:(options, handler){
          // Do something before request is sent


          print('send request ${options.uri}');
          print('headers ${options.headers}');
          print('data: ${options.data}');

          return handler.next(options); //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
        },
        onResponse:(response,handler) {
          // Do something with response data
          print(response.data);
          return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
        },
        onError: (DioError e, handler) {
          // Do something with response error
          print('response: ${e.response}');
          print('statusCode: ${e.response?.statusCode}');
          print('data: ${e.response?.data}');
          print("error ${e.error}");
          print("message ${e.message}");
          print("type ${e.type}");
          if (e.response?.statusCode == 400) {
            return handler.next(e);
          } else if (e.response?.statusCode == 401) {
            return handler.next(e);
          } else if (e.response?.statusCode == 500) {

            //TODO show toast
          } else if (e.response == null) {
            //TODO show toast

          }
          return  handler.next(e);//continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
        }
    ));
    authDio.interceptors.add(InterceptorsWrapper(
        onRequest:(options, handler){
          // Do something before request is sent
       options.headers = server.headers;

          print('send request ${options.uri}');
          print('headers ${options.headers}');
          print('data on request: ${options.data}');
          return handler.next(options); //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
        },
        onResponse:(response,handler) {
          // Do something with response data
          print('data: ${response.data}');
          if (response.statusCode == 200) {
            return handler.next(response); // continue

          }
          return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
        },
        onError: (DioError e, handler) {
          // Do something with response error
          print('DioError Type ${e.type}');
          print('DioError Status Code ${e.response?.statusCode}');
          print('DioEror Response Data${e.response?.data}');
          if (e.response?.statusCode == 400) {
            return handler.resolve(e.response!);
          }
          if (e.response?.statusCode == 401) {

            handler.resolve(e.response!);
          }
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
          return handler.next(e); // continue

        }
    ));


  }



}