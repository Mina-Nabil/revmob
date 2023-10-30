import 'dart:io';
import 'package:dio/dio.dart';
import 'package:revmo/environment/network_layer.dart';
import 'package:http_parser/http_parser.dart';

class RequestDocumentsService {

  NetworkLayer _service =  NetworkLayer();

  Future<Response> deleteImageUrl(int docID){
    return _service.authDio.delete("/api/seller/offers/document/$docID/file");
  }

  Future<Response> deleteDocument(int docId) {
    return _service.authDio
        .delete('/api/seller/offers/document/$docId');

  }

  Future<Response> uploadDocumentFieldImage(
      int offerID,
      File? image,
      ) async {
    String fileName = image!.path.split('/').last;
    print(fileName);

    var data = FormData.fromMap({
      'id': offerID.toString(),
      "document": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
        contentType: MediaType('application', 'x-tar'),
      ),
    });

    return _service.authDio.post('/api/seller/offers/document/file', data: data

    );
  }


  Future<Response> uploadOfferDocument(
      int offerID,
      String title,
      String note,

      File? image,
      ) async {

    if(image != null) {

      String fileName = image.path.split('/').last;
      print(fileName);

      var data = FormData.fromMap({
        'offer_id': offerID.toString(),
        'title': title,
        'note':note,
        "document": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: MediaType('application', 'x-tar'),
        ),
      });
      return _service.authDio.post('/api/seller/offers/document', data: data
      );
    }else {


      var data = FormData.fromMap({
        'offer_id': offerID.toString(),
        'title': title,
        'note':note,


      });
      return _service.authDio.post('/api/seller/offers/document', data: data
      );
    }

  }

  Future<Response> getOfferDocuments(int offerID) {
    return _service.authDio
        .get('/api/seller/offers/$offerID/documents',);
  }
}