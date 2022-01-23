import 'package:flutter/material.dart';
import 'package:revmo/environment/api_response.dart';
import 'package:revmo/models/accounts/join_request.dart';
import 'package:revmo/models/accounts/showroom.dart';
import 'package:revmo/models/accounts/seller.dart';
import 'package:revmo/services/account_service.dart';
import 'package:revmo/services/auth_service.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class AccountProvider extends ChangeNotifier {
  Seller? _currentUser;
  List<Seller>? _showroomTeam;
  List<Seller>? _sellersSearch;
  List<JoinRequest>? _sellersRequests;
  List<Showroom>? _showroomSearch;
  List<JoinRequest>? _showroomInvitations;

  Seller? get user => _currentUser;
  Showroom? get showroom => (user != null) ? user!.showroom : null;
  List<Seller>? get team => _showroomTeam;
  List<Seller>? get sellersToAdd => _sellersSearch != null && _sellersSearch!.length > 0
      ? _sellersSearch
      : _sellersRequests != null
          ? _sellersRequests!.map((jr) => jr.seller).toList()
          : null;
  List<Showroom>? get showroomToAdd => _showroomSearch != null && _showroomSearch!.length > 0
      ? _showroomSearch
      : _showroomInvitations != null
          ? _showroomInvitations!.map((jr) => jr.showroom).toList()
          : null;

  Future<Seller?> login(context, String email, String password) async {
    clearUser();
    var response = await AuthService.login(context, identifier: email, password: password);
    if (response.status == true && response.body is Seller) {
      _currentUser = response.body;
      notifyListeners();
      return response.body!;
    } else {
      print(response.msg);
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(response.msg)));
      if (response.errors != null && response.errors!.length > 0) {
        response.errors!.forEach((field, msg) {
          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(msg.toString())));
        });
      }
    }
    return null;
  }

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

  Future loadTeam(context, {bool forceReload = false}) async {
    ApiResponse<List<Seller>?> response =
        await AccountService.getShowroomTeam(context, loadedShowroom: _currentUser != null ? _currentUser!.showroom : null);
    if (response.status == true) {
      this._showroomTeam = response.body;
    }
    notifyListeners();
  }

  Future loadShowroomRequestsAndInvitations(context) async {
    ApiResponse<List<JoinRequest>?> response = await AccountService.getShowromJoinRequestsAndInvitations(context);
    if (response.status == true) {
      this._sellersRequests = response.body;
    }
    notifyListeners();
  }

  Future searchSellers(context, String searchText) async {
    ApiResponse<List<Seller>?> response = await AccountService.searchSellers(context, searchText);
    if (response.status == true) {
      this._sellersSearch = response.body;
      if (this._sellersSearch != null && team != null) {
        this._sellersSearch!.forEach((seller) {
          if (_sellersRequests != null && _sellersRequests!.map((jr) => jr.seller).contains(seller)) {
            seller.requestedStatus = _sellersRequests!.firstWhere((jr) => jr.seller == seller).status;
          }
          seller.inTeam = (_showroomTeam != null && _showroomTeam!.contains(seller));
        });
      }
    }
    notifyListeners();
  }

  Future loadSellerRequestsAndInvitations(context) async {
    ApiResponse<List<JoinRequest>?> response = await AccountService.getSellerInvitationsAndRequests(context);
    if (response.status == true) {
      this._showroomInvitations = response.body;
    }
    notifyListeners();
  }

  clearSellersSearch() {
    if (_sellersSearch != null && _sellersSearch!.isNotEmpty) _sellersSearch!.clear();
    notifyListeners();
  }

  Future searchShowrooms(context, String searchText) async {
    ApiResponse<List<Showroom>?> response = await AccountService.searchShowrooms(context, searchText);
    if (response.status == true) {
      this._showroomSearch = response.body;
      if (this._showroomSearch != null)
        this._showroomSearch!.forEach((showroom) {
          if (_showroomInvitations != null && _showroomInvitations!.map((jr) => jr.showroom).contains(showroom)) {
            showroom.requestedStatus = _showroomInvitations!.firstWhere((jr) => jr.showroom == showroom).status;
          }
        });
    }
    notifyListeners();
  }

  clearShowroomsSearch() {
    if (_showroomSearch != null && _showroomSearch!.isNotEmpty) _showroomSearch!.clear();
    notifyListeners();
  }

  clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  ///request functions
  //Showroom Owner functions
  Future cancelInvitationRequest(context, Seller seller) async {
    if (_currentUser != null && _currentUser!.showroom != null && _currentUser!.canManage && _sellersRequests != null) {
      JoinRequest? request;
      try {
        request = _sellersRequests!.firstWhere((request) => request.seller == seller);
      } catch (e) {
        print(e);
      }
      if (request != null) {
        ApiResponse<bool> response = await AccountService.deleteRequest(context, request.id);
        if (response.status == true && response.body == true) {
          seller.requestedStatus = null;
          if (_sellersRequests != null) _sellersRequests!.remove(request);
          if (_showroomInvitations != null) _showroomInvitations!.remove(request);
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: RevmoTheme.getBody(response.msg, 1, color: RevmoColors.darkBlue)));
        }
      }
    }
  }

  Future<bool> acceptJoinRequest(context, Seller seller) async {
    if (_currentUser != null && _currentUser!.showroom != null && _currentUser!.canManage && _sellersRequests != null) {
      JoinRequest? joinRequest;
      try {
        joinRequest = _sellersRequests!.firstWhere((request) => request.seller == seller);
      } catch (e) {
        print(e);
      }
      if (joinRequest != null) {
        ApiResponse<bool> response = await AccountService.acceptRequest(context, joinRequest.id);
        if (response.status == true && response.body == true) {
          if (_sellersRequests != null) {
            joinRequest.status = JoinRequestStatus.Accepted;
            joinRequest.seller.inTeam = true;
            joinRequest.seller.showroom = _currentUser!.showroom;
            if (team != null) team!.add(joinRequest.seller);
            if (_sellersSearch != null) {
              try {
                Seller loadedSearchSeller = _sellersSearch!.firstWhere((s) => s == joinRequest!.seller);
                loadedSearchSeller.inTeam = true;
                loadedSearchSeller.showroom = _currentUser!.showroom;
              } catch (e) {}
            }
          }
          notifyListeners();
          return true;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: RevmoTheme.getBody(response.msg, 1, color: RevmoColors.darkBlue)));
        }
      }
    }
    return false;
  }

  Future sendInvitation(context, Seller seller) async {
    if (_currentUser != null && _currentUser!.showroom != null) {
      ApiResponse<JoinRequest?> response = await AccountService.sendSellerInvitation(context, seller.id);
      if (response.status == true && response.body is JoinRequest) {
        JoinRequest joinRequest = response.body!;
        if (_sellersRequests != null) _sellersRequests!.add(joinRequest);
        try {
          Seller loadedSearchSeller = _sellersSearch!.firstWhere((s) => s == joinRequest.seller);
          loadedSearchSeller.requestedStatus = JoinRequestStatus.InvitedByShowroom;
        } catch (e) {}
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: RevmoTheme.getBody(response.msg, 1, color: RevmoColors.darkBlue)));
      }
    }
  }

  //Seller Functions
  Future declineInvitation(context, Showroom showroom) async {
    if (_currentUser != null && _currentUser!.showroom == null) {
      JoinRequest? request;
      try {
        request = _showroomInvitations!.firstWhere((request) => request.showroom == showroom);
      } catch (e) {
        print(e);
      }
      if (request != null) {
        ApiResponse<bool> response = await AccountService.deleteRequest(context, request.id);
        if (response.status == true && response.body == true) {
          if (_sellersRequests != null) _sellersRequests!.remove(request);
          if (_showroomInvitations != null) _showroomInvitations!.remove(request);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: RevmoTheme.getBody(response.msg, 1, color: RevmoColors.darkBlue)));
        }
        notifyListeners();
      }
    }
  }

  Future<bool> acceptInvitation(context, Showroom showroom) async {
    if (_currentUser != null && _currentUser!.showroom == null) {
      JoinRequest? joinRequest;
      try {
        joinRequest = _showroomInvitations!.firstWhere((request) => request.showroom == showroom);
      } catch (e) {
        print(e);
      }
      if (joinRequest != null) {
        ApiResponse<bool> response = await AccountService.acceptInvitation(context, joinRequest.id);
        if (response.status == true && response.body == true) {
          if (_sellersRequests != null) {
            joinRequest.status = JoinRequestStatus.Accepted;
            _currentUser!.inTeam = true;
            _currentUser!.showroom = showroom;
            if (team != null) team!.add(joinRequest.seller);
          }
          notifyListeners();
          return true;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: RevmoTheme.getBody(response.msg, 1, color: RevmoColors.darkBlue)));
        }
      }
    }
    return false;
  }

  Future sendJoinRequest(context, Showroom showroom) async {
    if (_currentUser != null && _currentUser!.showroom == null) {
      ApiResponse<JoinRequest?> response = await AccountService.sendShowroomJoinRequest(context, showroom.id);
      if (response.status == true && response.body is JoinRequest) {
        JoinRequest joinRequest = response.body!;
        if (_showroomInvitations != null) _showroomInvitations!.add(joinRequest);
        try {
          Showroom loadedShowroomSearch = _showroomSearch!.firstWhere((s) => s == joinRequest.showroom);
          loadedShowroomSearch.requestedStatus = JoinRequestStatus.RequestedBySeller;
        } catch (e) {}
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: RevmoTheme.getBody(response.msg, 1, color: RevmoColors.darkBlue)));
      }
      notifyListeners();
    }
  }
}
