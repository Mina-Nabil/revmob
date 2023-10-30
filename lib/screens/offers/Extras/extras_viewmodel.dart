import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:revmo/models/offers/extra_model.dart';
import 'package:revmo/screens/offers/Extras/extras_services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../models/offers/offer.dart';

class ExtraViewModel extends ViewModel {
  final Offer offer;

  ExtraViewModel({required this.offer});

  ExtrasServices _service = ExtrasServices();


  List<Extras> extras=[];

  bool loading = false;

  bool ignoring = false;

  final ImagePicker _picker = ImagePicker();

  File? picture;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  Future addPhoto() async {
    try {
      Future.delayed(const Duration(milliseconds: 300), () {
        loading = true;
        notifyListeners();
      });

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        loading = false;
        notifyListeners();
        return image;
      } else {
        loading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  fetchExtras() async {
    return await _service.getExtras(offer.id).then((value) {
      if (value.statusCode == 200 && value.data["status"]) {
        // value.data["body"]["wanted_docs"].entries
        //     .map((entry) => documents.add(Docs.fromJson(entry.value)))
        //     .toList();
        // documents = List<Docs>.from(
        //     value.data["body"]["wanted_docs"].map((x) => Docs.fromJson(x)));
        extras = List<Extras>.from(
            value.data["body"].map((x) => Extras.fromJson(x)));
        // value.data["body"]["seller_docs"].entries
        //     .map((entry) => sellerDocuments.add(Docs.fromJson(entry.value)))
        //     .toList();
        notifyListeners();
      } else {}
    });
  }


  Future<bool> uploadDocument() {
    try{
      return _service
          .uploadExtra(
          offer.id,
          titleController.text,
          noteController.text,
          priceController.text,
          picture! )
          .then((value) {
        if (value.statusCode == 200) {
          ignoring = true;
          notifyListeners();
          return Future.value(true);
        } else {
          ignoring = false;
          notifyListeners();
          return Future.value(false);
        }
      });
    }on DioError catch(e){
      print('sdsddadsad');
      print(e);
      return Future.value(false);

    }

  }
  Future<bool> deleteDocument(int id) {
    try{
      return _service
          .deleteExtra(
          id,)
          .then((value) {
        if (value.statusCode == 200) {
          ignoring = true;
          notifyListeners();
          return Future.value(true);
        } else {
          ignoring = false;
          notifyListeners();
          return Future.value(false);
        }
      });
    }on DioError catch(e){
      print('sdsddadsad');
      print(e);
      return Future.value(false);

    }

  }


  Future? _getExtrasFuture;

  Future? get getExtrasFuture => _getExtrasFuture;


  @override
  void init() {
    _getExtrasFuture = fetchExtras();
    // TODO: implement init
    super.init();
  }
}
