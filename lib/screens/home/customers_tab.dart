import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';

class CustomersTab extends StatelessWidget {
  static const String screenName = "customerTab";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RevmoAppBar(),
        backgroundColor: RevmoColors.darkBlue,
        body: Container(
          child: Text("Ana customers"),
        ));
  }
}
