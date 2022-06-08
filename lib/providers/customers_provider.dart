import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/Customers/CUSTOMERS_MODDEL_MODEL.dart';
import '../services/customers_service.dart';
import 'package:revmo/shared/theme.dart';

class CustomersProvider extends ChangeNotifier {
  BuildContext context;

  CustomersProvider(this.context);




  CustomersService _catalogService = new CustomersService();


  String searchType = 'buyerName';
  int searchTypeCheck = 0;


  final _search = TextEditingController();
  TextEditingController get search => _search;

  List<SoldOffer> _customersList = [];

  List<SoldOffer> get customersList => _customersList;

  List<SoldOffer> _displayedCustomersList = [];

  List<SoldOffer> get displayedCustomersList => _displayedCustomersList;



  void setSearchType(String type){
    searchType = type;


    if(type == 'buyerName') {
      searchTypeCheck = 0;
    }else if(type =='sellerName' ) {
      searchTypeCheck = 1;
    }

    notifyListeners();
  }

  void searchInTeam(String searchWord) {
    if (searchWord.isEmpty) {
      _displayedCustomersList.clear();
    }

    if(searchType == 'buyerName' ) {
      _displayedCustomersList = _customersList
          .where((element) => element.buyer!.fullName.contains(searchWord))
          .toList();
    }else if(searchType == 'sellerName' ) {
      _displayedCustomersList = _customersList
          .where((element) => element.seller!.sellerName!.contains(searchWord))
          .toList();
    }

    notifyListeners();
  }


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setLoading(bool status){
    _isLoading = status;
    notifyListeners();
  }

  Future? _customersFuture;

  Future? get customersFuture => _customersFuture;

  setFuture() {
    _customersFuture = fetchCustomers();
    notifyListeners();
  }

  Future fetchCustomers() async {
    try {
      setLoading(true);
      return await _catalogService.getCustomers().then((value) {
        var decoded = jsonDecode(value.body);
        setLoading(false);
        if (value.statusCode == 200 && decoded["status"] == true) {
          var decoded = jsonDecode(value.body);

          print('Body---------------------------');
          print(value.body);
          print('-----------------------------------');
          print('message: ' + decoded['message']);
          print('-----------------------------------');
          print('status: ' + decoded['status'].toString());

          /////////////////////////////////////////
          List<SoldOffer> customersListRequest = List<SoldOffer>.from(
              decoded["body"]["soldOffers"].map((x) => SoldOffer.fromJson(x)));
          // _customersList.clear();
          _customersList = customersListRequest;
          _displayedCustomersList = customersListRequest;
          _customersList.sort((a, b) => a.offerPrice!.compareTo(b.offerPrice!));
          _displayedCustomersList.sort((a, b) => a.offerPrice!.compareTo(b.offerPrice!));
          print('customers length :  ${customersListRequest.length}');
          notifyListeners();
          return Future.value(true);
        } else {
          print('---------------------------');
          print('status code---------------------------');
          print(value.statusCode);
          print('error');
          print('Body---------------------------');
          print(value.body);
          RevmoTheme.showRevmoSnackbar(context, 'Something Went Wrong');
          // return Future.value(false);
        }
      });
    } catch (e) {
      setLoading(false);
      print(e);

      // return Future.value(false);
    }
  }
}
