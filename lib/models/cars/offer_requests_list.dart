import 'dart:collection';

import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/models/offers/offer_request.dart';

import 'brand.dart';

class OfferRequestsList{

    List<OfferRequest> _offerRequests = [];

    HashSet<Brand> _availableBrands = new HashSet();
    HashSet<ModelColor> _availableColors = new HashSet();
    HashSet<Car> _availableCars = new HashSet();
    double _minPrice = 0;
    double _maxPrice = double.maxFinite;

    OfferRequestsList({required List<OfferRequest> offerRequests}){
      this._offerRequests=offerRequests;
      offerRequests.forEach((or) {
        _availableBrands.add(or.car.model.brand);
        _availableColors.addAll(or.colors);
        _availableCars.add(or.car);
      });
    }

    List<OfferRequest> filterByBrands({List<Brand> brands = const []}) {
      List<OfferRequest> filtered = [];

      // _offerRequests.forEach((element) {
      //   if(_offerRequests.contains(bra))
      //   filtered.add(value)
      // });

      return filtered;
    }

    // List<OfferRequest> filterByModels(){}
    //
    // List<OfferRequest> filterByCars(){}
    //
    // List<OfferRequest> filterByColors(){}


}