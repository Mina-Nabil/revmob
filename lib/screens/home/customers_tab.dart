import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';

class CustomersTab extends StatelessWidget {
  static const String screenName = "customerTab";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: Container(
          child: Text("Ana customers"),
        ));
  }
}
