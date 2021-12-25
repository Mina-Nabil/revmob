import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';

class RequestsTab extends StatelessWidget {
  static const screenName = "requestsTab";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: RevmoAppBar(),
        backgroundColor: RevmoColors.darkBlue,
        body: Container(
          child: Text("                                       Ana requests"),
        ));
  }
}
