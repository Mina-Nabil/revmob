import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../colors.dart';

class SuccessMessage extends StatelessWidget {
  const SuccessMessage({
    Key? key, required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      // actions: [
      //   ElevatedButton(onPressed: (){
      //     Navigator.pop(context);
      //   }, child: Text('dismiss'))
      // ],
      content: Container(
        height: 150,
        child:
        Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Lottie.asset('assets/images/checked.json',
              repeat: false, height: 100, frameRate: FrameRate.max),
          FadeIn(
              child: Text(
                message,
                style: TextStyle(color: RevmoColors.darkBlue),
              ))
        ]),
      ),
    );
  }
}