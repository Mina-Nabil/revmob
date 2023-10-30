import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {



  static void showUnExpectedErrorToast() {
    Fluttertoast.showToast(
      msg: "something went wrong please try again later",
      backgroundColor: const Color(0xFFDC3545),
      textColor: Colors.white,
      fontSize: 14,
      timeInSecForIosWeb: 2,
    );
  }

  static void showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: const Color(0xFFDC3545),
      textColor: Colors.white,
      fontSize: 14,
      timeInSecForIosWeb: 2,
    );
  }

  static void showSuccessToast(String msg,  [Color? color, Color? textColor]) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color ?? Colors.green[800],
      textColor:textColor ?? Colors.white,
      fontSize: 14,
      timeInSecForIosWeb: 2,
    );
  }
}
