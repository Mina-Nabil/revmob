import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/Customers/CUSTOMERS_MODDEL_MODEL.dart';
import '../../services/customers_service.dart';
import 'package:revmo/shared/theme.dart';

class CustomersProvider extends ChangeNotifier {
  BuildContext context;

  CustomersProvider(this.context);

  bool isConnected = true;

  CustomersService _customersService = new CustomersService();

  final _search = TextEditingController();

  TextEditingController get search => _search;

  List<SoldOffer> _customersList = [];

  List<SoldOffer> get customersList => _customersList;

  List<SoldOffer> _displayedCustomersList = [];

  List<SoldOffer> get displayedCustomersList => _displayedCustomersList;


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }



  double get minCarPrice {
    double minPrice = double.maxFinite;
    _customersList.forEach((car) {
      if (car.offerPrice!.toDouble() < minPrice) minPrice = car.offerPrice!.toDouble();
    });
    return minPrice==double.maxFinite ? 0 : minPrice;
  }

 set maxCarPrice(double){
    maxCarPrice = double;
    notifyListeners();
  }


  double get maxCarPrice {
    double maxPrice = double.minPositive;
    _customersList.forEach((car) {
      if (car.offerPrice!.toDouble() > maxPrice) maxPrice = car.offerPrice!.toDouble();
    });
    return maxPrice==double.minPositive ? 0 : maxPrice;
  }
///////////////////////Fetching Data//////////////////////

  Future fetchCustomersNetworkLayer() async {
    try {
      setSortByIndex(10);
      setLoading(true);
      dio.Response response = await _customersService.getCustomersNetworkLayer();
      isConnected = true;

      setLoading(false);

      List<SoldOffer> customersListRequest = List<SoldOffer>.from(response
          .data["body"]["soldOffers"].map((x) => SoldOffer.fromJson(x)));
      _customersList = customersListRequest;
      _displayedCustomersList = customersListRequest;
      _customersList.sort((a, b) => a.offerPrice!.compareTo(b.offerPrice!));
      _displayedCustomersList
          .sort((a, b) => a.offerPrice!.compareTo(b.offerPrice!));

      print('customers length :  ${customersListRequest.length}');
      notifyListeners();
    } on dio.DioError catch (e) {
      print('----------$e');
      if (e.response?.statusCode == null || e.response?.data == null) {
        isConnected = false;
        notifyListeners();
        // RevmoTheme.showRevmoSnackbar(context, 'No internet Connection');
      } else {
        RevmoTheme.showRevmoSnackbar(context, 'SomeThing Went Wrong');
      }
    }
  }

  Future? _customersFuture;

  Future? get customersFuture => _customersFuture;

  setFuture() {
    // _customersFuture = fetchCustomers();
    _customersFuture = fetchCustomersNetworkLayer();
    notifyListeners();
  }

  //--------------- End ---------------

//////////////////////Search ///////////////
  void searchInTeam(String searchWord) {
    if (searchWord.isEmpty) {
      _displayedCustomersList.clear();
    }
    _displayedCustomersList = _customersList
        .where((element) =>
            element.buyer!.fullName.contains(searchWord) ||
            element.seller!.sellerName!.contains(searchWord))
        .toList();

    notifyListeners();
  }

  //--------------- End ---------------

  ////////////////////Sorting/////////////////////////
  int sortTypeCheck = 10;
  int sortPriceIndex = 5;

  setSortByIndex(int) {
    sortTypeCheck = int;
    sortPriceIndex = 5;

    notifyListeners();
  }

  setSortPriceByIndex(int) {
    sortPriceIndex = int;
    sortTypeCheck = 10;
    notifyListeners();
  }

  sortByCreationDate() {
    _displayedCustomersList
        .sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    print('sorted to creation date');

    notifyListeners();
  }

  sortByExpiryDate() {
    _displayedCustomersList
        .sort((a, b) => a.offerExpiryDate!.compareTo(b.offerExpiryDate!));
    print('sorted to expiry date');

    notifyListeners();
  }

  sortByPrice(bool highToLow) {
    if (highToLow == true) {
      _displayedCustomersList
          .sort((a, b) => b.offerPrice!.compareTo(a.offerPrice!));
      print('sorted to high to low');
    } else {
      _displayedCustomersList
          .sort((a, b) => a.offerPrice!.compareTo(b.offerPrice!));
      print('sorted by low to high');
    }
    notifyListeners();
  }

  resetSortBy() {
    setSortByIndex(10);
    _displayedCustomersList
        .sort((a, b) => a.offerPrice!.compareTo(b.offerPrice!));
    print('reset list to original');
    notifyListeners();
  }

//--------------- End ---------------

}
