
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  BuildContext context;

  HomeProvider(this.context);
  bool appBar = true;

  setAppBar(){
    appBar = !appBar;
    notifyListeners();
  }
}