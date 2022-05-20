import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/models/offers/offer.dart';
import 'package:revmo/models/offers/offer_request.dart';
import 'package:revmo/providers/account_provider.dart';
import 'package:revmo/services/offers_service.dart';
import 'package:revmo/shared/theme.dart';

class OffersProvider extends ChangeNotifier {
  final BuildContext context;
  OffersProvider(this.context);

  List<OfferRequest> _new = [];
  List<OfferRequest> get newRequests => _new;

  List<Offer> _pending = [];
  List<Offer> get pending => _pending;

  List<Offer> _approved = [];
  List<Offer> get approved => _approved;

  List<Offer> _expired = [];
  List<Offer> get expired => _expired;

  Future<Offer?> submitOffer(OfferRequest offerRequest, double price, double minDownpayment, List<int> offeredColorsIDs, DateTime start, DateTime end, [String? comment, bool setAsDefault=false]) async {
    Seller? _offerIssuer = Provider.of<AccountProvider>(context).user;
    if(_offerIssuer!=null){
      ApiResponse offerSubmissionResponse = await OffersService.submitNewOffer(context, offerRequest.id, price, minDownpayment, true, start, end, offeredColorsIDs);
    } else {
      return Future.value(null);
    }
  }

  loadOfferRequests({forceReload = false}) async {
    if (_new.isEmpty || forceReload) {
      ApiResponse<List<OfferRequest>?> response = await OffersService.getAvailableOfferRequests(context);
      if (response.body != null && response.body is List<OfferRequest>) {
        _new.clear();
        _new = response.body!;
        notifyListeners();
      } else {
        RevmoTheme.showRevmoSnackbar(context, response.msg);
      }
    }
  }

  loadPendingOffers({forceReload = false}) async {
    if (_pending.isEmpty || forceReload) {
      ApiResponse<List<Offer>?> response = await OffersService.getPendingOffers(context);
      if (response.body != null && response.body is List<Offer>) {
        _pending.clear();
        _pending = response.body!;
        notifyListeners();
      } else {
        RevmoTheme.showRevmoSnackbar(context, response.msg);
      }
    }
  }

  loadApprovedOffers({forceReload = false}) async {
    if (_approved.isEmpty || forceReload) {
      ApiResponse<List<Offer>?> response = await OffersService.getApprovedOffers(context);
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
      ApiResponse<List<Offer>?> response = await OffersService.getExpiredOffers(context);
      if (response.body != null && response.body is List<Offer>) {
        _expired.clear();
        _expired = response.body!;
        notifyListeners();
      } else {
        RevmoTheme.showRevmoSnackbar(context, response.msg);
      }
    }
  }
}
