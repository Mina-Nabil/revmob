import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../models/offers/docs_model.dart';
import '../../../models/offers/offer.dart';
import 'request_documents_service.dart';

class RequestDocumentsViewModel extends ViewModel {
  final Offer offer;

  RequestDocumentsViewModel({required this.offer});

  final RequestDocumentsService _services = RequestDocumentsService();

  List<Docs> documents = [];
  List<Docs> sellerDocuments = [];

  fetchDocuments() async {
    return await _services.getOfferDocuments(offer.id).then((value) {
      if (value.statusCode == 200 && value.data["status"]) {

        // value.data["body"]["wanted_docs"].entries
        //     .map((entry) => documents.add(Docs.fromJson(entry.value)))
        //     .toList();
        documents = List<Docs>.from(
            value.data["body"]["wanted_docs"].map((x) => Docs.fromJson(x)));
        sellerDocuments = List<Docs>.from(
            value.data["body"]["seller_docs"].map((x) => Docs.fromJson(x)));

        // value.data["body"]["seller_docs"].entries
        //     .map((entry) => sellerDocuments.add(Docs.fromJson(entry.value)))
        //     .toList();
        print(documents.length);
        print(sellerDocuments.length);
        notifyListeners();
      } else {}
    });
  }

  Future? _getDocsFuture;

  Future? get getDocsFuture => _getDocsFuture;

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  File? photoFromDevice;

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

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool ignoring = false;

  Future<bool> uploadDocument() {
    return _services
        .uploadOfferDocument(
            offer.id,
            titleController.text,
            noteController.text,
            photoFromDevice != null ? photoFromDevice : null)
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
  }


  @override
  void init() {
   _getDocsFuture =  fetchDocuments();
    // TODO: implement init
    super.init();
  }
}
