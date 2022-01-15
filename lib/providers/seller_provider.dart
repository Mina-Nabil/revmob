import 'package:flutter/material.dart';
import 'package:revmo/models/users/seller.dart';
import 'package:revmo/services/auth_service.dart';

class SellerProvider extends ChangeNotifier {
  Seller? _currentUser;

  SellerProvider();

  Seller? get user => _currentUser;

  Future loadUser(context, {bool forceReload = false}) async {
    if (forceReload || (_currentUser == null)) {
      clearUser();
      var response = await AuthService.getCurrentUser(context);
      if (response.status == true) {
        _currentUser = response.body;
      }
    }
    notifyListeners();
  }

  clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
