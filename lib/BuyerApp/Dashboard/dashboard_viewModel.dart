import 'package:flutter/material.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:pmvvm/view_model.dart';
import 'package:revmo/providers/Seller/customers_provider.dart';

import '../../models/offers/offer.dart';
import '../../providers/Buyer/home_provider.dart';
import '../../providers/Seller/offers_provider.dart';

class DashboardViewModel extends ViewModel {

 late var customerProvider = Provider.of<OffersProvider>(context) ;
@override
  void init() {
  customerProvider = Provider.of<OffersProvider>(context);
  customerProvider.loadPendingOffers();
    // TODO: implement init
    super.init();
  }

  int counter = 0;

 // late List<Offer> test = customerProvider.pending;

void increase() {
  counter++;
  notifyListeners();
}


}