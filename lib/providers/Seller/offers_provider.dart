import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/models/offers/offer.dart';
import 'package:revmo/models/offers/offer_request.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/services/offers_service.dart';
import 'package:revmo/shared/theme.dart';

import '../../models/cars/brand.dart';

class OffersProvider extends ChangeNotifier {
  final BuildContext context;

  OffersProvider(this.context);

  List<OfferRequest> _new = [];

  List<OfferRequest> get newRequests => _new;
  List<OfferRequest> _displayedNew = [];

  List<OfferRequest> get displayedNew => _displayedNew;

  List<Offer> _pending = [];

  List<Offer> get pending => _pending;
  List<Offer> _displayedPending = [];

  List<Offer> get displayedPending => _displayedPending;

  List<Offer> _approved = [];

  List<Offer> get approved => _approved;
  List<Offer> _displayedApproved = [];

  List<Offer> get displayedApproved => _displayedApproved;

  List<Offer> _expired = [];

  List<Offer> get expired => _expired;
  List<Offer> _displayedExpired = [];

  List<Offer> get displayedExpired => _displayedExpired;

  OffersService _service = OffersService();

  ///OLD NETWORK LAYER CHANGING WITH TIME
  loadOfferRequests({forceReload = false}) async {
    if (_new.isEmpty || forceReload) {
      ApiResponse<List<OfferRequest>?> response =
          await OffersService.getAvailableOfferRequests(context);
      if (response.body != null && response.body is List<OfferRequest>) {
        _new.clear();
        _new = response.body!;
        _displayedNew = response.body!;
        notifyListeners();
      } else {
        RevmoTheme.showRevmoSnackbar(context, response.msg);
      }
    }
  }

  loadPendingOffers({forceReload = false}) async {
    if (_pending.isEmpty || forceReload) {
      ApiResponse<List<Offer>?> response =
          await OffersService.getPendingOffers(context);
      if (response.body != null && response.body is List<Offer>) {
        _pending.clear();
        _pending = response.body!;
        _pending.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        _displayedPending = response.body!;
        _displayedPending.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        print(_pending.length);
        notifyListeners();
      } else {
        RevmoTheme.showRevmoSnackbar(context, response.msg);
      }
    }
  }

  loadApprovedOffers({forceReload = false}) async {
    if (_approved.isEmpty || forceReload) {
      ApiResponse<List<Offer>?> response =
          await OffersService.getApprovedOffers(context);
      if (response.body != null && response.body is List<Offer>) {
        _approved.clear();
        _approved = response.body!;
        notifyListeners();
      } else {
        RevmoTheme.showRevmoSnackbar(context, response.msg);
      }
    }
  }

  loadExpiredOffers({forceReload = false}) async {
    if (_expired.isEmpty || forceReload) {
      ApiResponse<List<Offer>?> response =
          await OffersService.getExpiredOffers(context);
      if (response.body != null && response.body is List<Offer>) {
        _expired.clear();
        _expired = response.body!;
        notifyListeners();
      } else {
        RevmoTheme.showRevmoSnackbar(context, response.msg);
      }
    }
  }

  Future<dynamic> submitOffer(
      OfferRequest offerRequest,
      double price,
      double minDownpayment,
      List<int> offeredColorsIDs,
      String start,
      String end,
      bool isLoan,
      [String? comment,
      bool setAsDefault = false]) async {
    Seller? _offerIssuer =
        Provider.of<AccountProvider>(context, listen: false).user;
    if (_offerIssuer != null) {
      ApiResponse offerSubmissionResponse = await OffersService.submitNewOffer(
          context,
          offerRequest.id,
          price,
          minDownpayment,
          isLoan,
          start,
          end,
          offeredColorsIDs,
          comment);
      if (offerSubmissionResponse.status == true) {
        return Future.value(true);
      } else {
        RevmoTheme.showRevmoSnackbar(context, offerSubmissionResponse.msg);
        return Future.value(false);
      }
    } else {
      RevmoTheme.showRevmoSnackbar(context, 'Something went wrong ...');

      return Future.value(false);
    }
  }

  ///NEW NETWORK LAYER TRYING TO MAXIMISE USING IT
  ///
  ///

  /// FETCHING DATA
  Future<bool> loadPendingOffersNetworkLayer() async {
    try {
      return await _service.networkLayerGetPendingOffers().then((value) {
        if (value.statusCode == 200) {
          List<Offer> response = List<Offer>.from(
              value.data["body"]["offers"].map((x) => Offer.fromJson(x)));
          _pending.clear();
          _pending = response;
          _pending.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
          _displayedPending = _pending;

          notifyListeners();
          return Future.value(true);
        } else {
          print(value.statusCode);
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> loadApprovedOffersNetworkLayer() async {
    try {
      return await _service.networkLayerGetApprovedOffers().then((value) {
        if (value.statusCode == 200) {
          List<Offer> response = List<Offer>.from(
              value.data["body"]["offers"].map((x) => Offer.fromJson(x)));
          _approved.clear();
          _approved = response;
          // _approved.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
          _displayedApproved = _approved;

          notifyListeners();
          return Future.value(true);
        } else {
          print(value.statusCode);
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> loadExpiredOffersNetworkLayer() async {
    try {
      return await _service.networkLayerGetExpiredOffers().then((value) {
        if (value.statusCode == 200) {
          List<Offer> response = List<Offer>.from(
              value.data["body"]["offers"].map((x) => Offer.fromJson(x)));
          _expired.clear();
          _expired = response;
          _expired.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
          _displayedExpired = _expired;
          notifyListeners();
          return Future.value(true);
        } else {
          print(value.statusCode);
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  /// INTERACTIONS
  Future<bool> extendOffer(int id) {
    try {
      return OffersService().extendOffer(id).then((value) {
        var decoded = jsonDecode(value.body);

        if (value.statusCode == 200 && decoded["status"] == true) {
          print('Body---------------------------');
          print(value.body);
          print('-----------------------------------');
          print('message: ' + decoded['message']);
          print('-----------------------------------');
          print(
              'Expiration Date: ' + decoded['body']['offer']['OFFR_EXPR_DATE']);
          print('offer $id Extended succesfuly');
          return Future.value(true);
        } else {
          print('offer $id not extended ');
          print('---------------------------');
          print('status code---------------------------');
          print(value.statusCode);
          print('Body---------------------------');

          print(value.body);
          RevmoTheme.showRevmoSnackbar(
              context, decoded['message'] ?? 'Something Went Wrong');

          return Future.value(false);
        }
      });
    } on HttpException catch (error) {
      print(error);
      RevmoTheme.showRevmoSnackbar(context, 'Something Went Wrong');

      return Future.value(false);
    }
  }

  Future<bool> extendAllOffers() {
    try {
      return OffersService().extendAllOffers().then((value) {
        var decoded = jsonDecode(value.body);
        if (value.statusCode == 200 && decoded["status"] == true) {
          print('Body---------------------------');
          print(value.body);
          print('-----------------------------------');
          print('message: ' + decoded['message']);
          print('-----------------------------------');
          return Future.value(true);
        } else {
          print('---------------------------');
          print('status code---------------------------');
          print(value.statusCode);
          print('Body---------------------------');
          print(value.body);
          print('message: ' + decoded['message']);
          print('-----------------------------------');
          RevmoTheme.showRevmoSnackbar(
              context, decoded['message'] ?? 'Something Went Wrong');
          return Future.value(false);
        }
      });
    } on HttpException catch (error) {
      print(error);
      return Future.value(false);
    }
  }

  Future<bool> cancelPendingOffer(int id) {
    try {
      return OffersService().networkLayerCancelPendingOffers(id).then((value) {
        if (value.statusCode == 200) {
          return Future.value(true);
        } else {
          RevmoTheme.showRevmoSnackbar(context, 'Something Went Wrong');

          return Future.value(false);
        }
      });
    } on HttpException catch (error) {
      print(error);
      RevmoTheme.showRevmoSnackbar(context, 'Something Went Wrong');

      return Future.value(false);
    }
  }

  ///SUBMIT OFFER
  Future<bool> submitOfferNetworkLayer(
      OfferRequest offerRequest,
      double price,
      double minDownpayment,
      List<int> offeredColorsIDs,
      String start,
      String end,
      bool isLoan,
      Map<String, String> options,
      [String? comment,
      bool setAsDefault = false]) async {
    try {
      return await _service
          .networkLayerSubmitOffer(offerRequest.id, price, minDownpayment,
              isLoan, start, end, options, offeredColorsIDs, comment)
          .then((value) {
        if (value.statusCode == 200) {
          // loadPendingOffers(forceReload: true);
          return Future.value(true);
        } else {
          print(value.statusCode);
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  removeIndexWithIdNew(int id) {
    print(id);
    print('this is length before ' + '${_new.isEmpty}');
    _new.removeWhere((element) => element.id == id);
    print('this is length' + '${_new.length}');
    notifyListeners();
  }

  ///SEARCH FEATURE
  searchInRequests(String searchWord, int id) {
    if (id == 0) {
      _displayedNew = _new.where((element) {
        print(element.car.carName);
        return element.car.carName.contains(searchWord);
      }).toList();
    } else if (id == 1) {
      _displayedPending = _pending.where((element) {
        print(element.car.carName);
        return element.car.carName
            .toLowerCase()
            .contains(searchWord.toLowerCase());
      }).toList();
    } else if (id == 2) {
      _displayedApproved = _approved.where((element) {
        return element.car.carName.contains(searchWord);
      }).toList();
    } else if (id == 3) {
      _displayedExpired = _expired.where((element) {
        return element.car.carName.contains(searchWord);
      }).toList();
    }
    notifyListeners();
  }
}
