import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/shared/theme.dart';

import '../../environment/network_layer.dart';
import '../../providers/Seller/account_provider.dart';
import '../../shared/colors.dart';
import '../../shared/widgets/UIwidgets/pin_code.dart';
import '../../shared/widgets/UIwidgets/success_message.dart';
import '../../shared/widgets/home/revmo_appbar.dart';
import '../../shared/widgets/misc/main_button.dart';

class VerifyView extends StatefulWidget {
  final String? mail;
  final String? phoneNumber;
  final String? phoneNumber2;

  const VerifyView({Key? key, this.mail, this.phoneNumber, this.phoneNumber2})
      : super(key: key);

  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  bool ignorePage = true;
  TextEditingController otpController = TextEditingController();
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> verifyMobNetworkLayer() {
    return _networkLayer.authDio.post('/api/seller/verify/mob', data: {
      "code": otpController.text,
      "mob": widget.phoneNumber ?? widget.phoneNumber2
    });
  }

  Future<Response> verifyMailNetworkLayer() {
    return _networkLayer.authDio.post('/api/seller/verify/email',
        data: {"code": otpController.text, "mail": widget.mail});
  }

  Future<Response> resendMob1() {
    return _networkLayer.authDio.post(
      '/api/seller/resend/mob1',
    );
  }

  Future<Response> resendMob2() {
    return _networkLayer.authDio.post(
      '/api/seller/resend/mob2',
    );
  }

  Future<Response> resendMailNetworkLayer() {
    return _networkLayer.authDio.post(
      '/api/seller/resend/email',
    );
  }

  Future<bool> resendCodeMob1() async {
    try {
      EasyLoading.show();
      return await resendMob1().then((value) async {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          RevmoTheme.showRevmoSnackbar(
              context, 'Verification code sent successfully');
          return Future.value(true);
        } else {
          RevmoTheme.showRevmoSnackbar(
              context, 'Something went wrong please try again');
          return Future.value(false);
        }
      });
    } catch (e) {
      RevmoTheme.showRevmoSnackbar(
          context, 'Something went wrong please try again');
      return Future.value(false);
    }
  }

  Future<bool> resendCodeMob2() async {
    try {
      EasyLoading.show();
      return await resendMob2().then((value) async {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          RevmoTheme.showRevmoSnackbar(
              context, 'Verification code sent successfully');
          return Future.value(true);
        } else {
          RevmoTheme.showRevmoSnackbar(
              context, 'Something went wrong please try again');
          return Future.value(false);
        }
      });
    } catch (e) {
      RevmoTheme.showRevmoSnackbar(
          context, 'Something went wrong please try again');
      return Future.value(false);
    }
  }

  Future<bool> resendMail() async {
    try {
      EasyLoading.show();
      return await resendMailNetworkLayer().then((value) async {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          RevmoTheme.showRevmoSnackbar(
              context, 'Verification code sent successfully');
          return Future.value(true);
        } else {
          RevmoTheme.showRevmoSnackbar(
              context, 'Something went wrong please try again');
          return Future.value(false);
        }
      });
    } catch (e) {
      RevmoTheme.showRevmoSnackbar(
          context, 'Something went wrong please try again');
      return Future.value(false);
    }
  }

  Future<bool> verifyMob() async {
    EasyLoading.show();
    try {
      return await verifyMobNetworkLayer().then((value) async {
        print(value.statusCode);
        if (value.statusCode == 200) {
          print('condition 1');

          await Provider.of<AccountProvider>(context, listen: false)
              .refresshUser(context, forceReload: true).then((value) {
            EasyLoading.dismiss();

            Navigator.pop(context);

            showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pop(true);
                  });
                  return SuccessMessage(
                      message:
                      "Mobile number Verified successfully"
                  );
                });
          });


          return Future.value(true);
        } else {
          EasyLoading.dismiss();
          print('error2');
          RevmoTheme.showRevmoSnackbar(context, 'The selected code is invalid');
          otpController.clear();
          print('error2');
          return Future.value(false);
        }
      });
    } catch (e) {
      RevmoTheme.showRevmoSnackbar(context, 'The selected code is invalid');
      otpController.clear();
      EasyLoading.dismiss();
      print('error3');
      return Future.value(false);
    }
  }

  Future<bool> verifyMail() async {
    EasyLoading.show();
    try {
      return await verifyMailNetworkLayer().then((value) async {
        print(value.statusCode);
        if (value.statusCode == 200) {
          print('condition 1');
          await Provider.of<AccountProvider>(context, listen: false)
              .refresshUser(context, forceReload: true).then((value) {
            EasyLoading.dismiss();


            Navigator.pop(context);

            showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pop(true);
                  });
                  return SuccessMessage(
                      message:
                      "Email Verified successfully"
                  );
                });
          });
          return Future.value(true);
        } else {
          EasyLoading.dismiss();

          print('error2');
          RevmoTheme.showRevmoSnackbar(context, 'The selected code is invalid');
          otpController.clear();
          return Future.value(false);
        }
      });
    } catch (e) {
      RevmoTheme.showRevmoSnackbar(context, 'The selected code is invalid');
      otpController.clear();
      EasyLoading.dismiss();
      print('error3');
      return Future.value(false);
    }
  }

  @override
  void initState() {
    if (widget.mail != null) {
      resendMail();
    }
    if (widget.phoneNumber != null) {
      resendCodeMob1();
    }
    if (widget.phoneNumber2 != null) {
      resendCodeMob2();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sellerProvider = Provider.of<AccountProvider>(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: RevmoAppBar(),
        backgroundColor: RevmoColors.darkBlue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.mail != null)
              Text(
                "Email Verification",
                style: TextStyle(fontSize: 25),
              ),
            if (widget.phoneNumber2 != null || widget.phoneNumber != null)
              Text(
                "Mobile Verification",
                style: TextStyle(fontSize: 25),
              ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 36),
                children: <TextSpan>[
                  TextSpan(
                    text: "We have sent code to your ",
                    style: TextStyle(fontSize: 16),
                  ),
                  if (widget.mail != null)
                    TextSpan(
                      text: "email :",
                      style: TextStyle(fontSize: 16),
                    ),
                  if (widget.phoneNumber != null || widget.phoneNumber2 != null)
                    TextSpan(
                      text: "phone number :",
                      style: TextStyle(fontSize: 16),
                    ),

                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            if (widget.mail != null)
              Text(
                widget.mail!,
                style: TextStyle(fontSize: 16),
              ),
            if (widget.phoneNumber != null)
              Text(
                widget.phoneNumber!,
                style: TextStyle(fontSize: 16),
              ),
            if (widget.phoneNumber2 != null)
              Text(
                widget.phoneNumber2!,
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: PinPutCode(
                enabled: false,
                controller: otpController,
                onCompleted: (s) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  if (widget.mail != null) {
                    verifyMail();
                  } else if (widget.phoneNumber != null ||
                      widget.phoneNumber2 != null) {
                    verifyMob();
                  }
                  debugPrint(s);
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Column(
              children: [
                MainButton(
                  text: "Verify Account",
                  width: double.infinity,
                  callBack: () async{
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    if (otpController.text.isNotEmpty &&
                        otpController.text.length == 4) {
                      if (widget.mail != null) {
                        verifyMail();
                      } else if (widget.phoneNumber != null ||
                          widget.phoneNumber2 != null) {
                        verifyMob();
                      }
                    } else {
                      RevmoTheme.showRevmoSnackbar(context, 'Please enter otp');
                    }
                    //   verify(
                    //       otp.text,
                    //       Provider.of<AccountProvider>(context, listen: false)
                    //           .emailSignUp
                    //           .toString())
                    //       .then((value) async {
                    //     if (value) {
                    //       Seller? loggedInUser =
                    //       await Provider.of<AccountProvider>(context,
                    //           listen: false)
                    //           .refresshUser(
                    //         context,
                    //       );
                    //       if (loggedInUser is Seller) {
                    //         await Provider.of<AccountProvider>(context,
                    //             listen: false)
                    //             .loadCurrentPlan();
                    //         // FirebaseMessaging.instance.getToken().then((value) async {
                    //         //   debugPrint("getToken FCM $value");
                    //         //   await Provider.of<AccountProvider>(context, listen: false)
                    //         //       .setFcmToken(value!);
                    //         // });
                    //         if (loggedInUser.hasShowroom)
                    //           Navigator.of(context).pushNamedAndRemoveUntil(
                    //             HomeScreen.ROUTE_NAME,
                    //             ModalRoute.withName('/'),
                    //           );
                    //         else
                    //           Navigator.of(context).pushNamedAndRemoveUntil(
                    //               PreLoginScreen.ROUTE_NAME,
                    //                   (Route<dynamic> route) => false);
                    //       }
                    //     } else {
                    //       RevmoTheme.showRevmoSnackbar(
                    //           context, 'The selected code is invalid');
                    //       otp.clear();
                    //       print('error');
                    //     }
                    //   });
                    // } else {
                    //   RevmoTheme.showRevmoSnackbar(context, 'Please enter otp');
                    // }
                  },
                ),
                MainButton(
                  text: "Resend code",
                  width: double.infinity,
                  color: RevmoColors.cyan.withOpacity(0.2),
                  callBack: () {
                    // Navigator.pop(context);
                    // resendCode();
                  },
                )
              ],
            ),
          ],
        ).setPageHorizontalPadding(context),
      ),
    );
  }
}
