import 'dart:js';

import 'package:flutter/material.dart';
import 'package:revmo/models/seller.dart';
import 'package:revmo/services/AuthService.dart';

class SellerProvider extends ChangeNotifier {
  Seller? _currentUser;

  Seller? get user => _currentUser;

  loadUser() async {
    if(_currentUser==null){
      var response = await AuthService.getCurrentUser(context);
      if(response.status==true){
        _currentUser=response.body;
      } 
    }
    notifyListeners();
  } 



}
