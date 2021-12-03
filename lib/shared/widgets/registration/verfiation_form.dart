import 'package:flutter/material.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/widgets/main_button.dart';

class VerficationForm extends StatefulWidget {
  final Duration animationsDuration;
  final Curve defaultCurve;
  const VerficationForm({this.animationsDuration = const Duration(milliseconds: 500), this.defaultCurve = Curves.easeIn});

  @override
  _VerficationFormState createState() => _VerficationFormState();
}

class _VerficationFormState extends State<VerficationForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(children: [
      Text("Verfication"),
      MainButton(
        text: "B3den",
        width: double.infinity,
        callBack: () {
          Navigator.of(context).pushNamed(HomeScreen.ROUTE_NAME);
        },
      )
    ]));
  }
}
