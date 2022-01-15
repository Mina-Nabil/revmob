import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';

class DashboardTab extends StatelessWidget {
  static const String screenName = "DashboardTab";

  const DashboardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: Container(
          child: Text("Ana dashboarddddddddd"),
        ));
  }
}
