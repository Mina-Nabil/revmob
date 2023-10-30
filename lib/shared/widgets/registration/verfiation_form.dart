import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/screens/auth/congratz_newaccount_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';

import '../../../environment/network_layer.dart';
import '../../../models/accounts/seller.dart';
import '../../../screens/auth/pre_login_screen.dart';
import '../../../screens/auth/signup_screen.dart';
import '../../../screens/home/home_screen.dart';
import '../../theme.dart';
import '../UIwidgets/pin_code.dart';

class VerficationForm extends StatefulWidget {
  final Duration animationsDuration;
  final Curve defaultCurve;
  final bool showRoom;

  const VerficationForm(
      {this.animationsDuration = const Duration(milliseconds: 500),
      this.showRoom = false,
      this.defaultCurve = Curves.easeIn});

  @override
  _VerficationFormState createState() => _VerficationFormState();
}

class _VerficationFormState extends State<VerficationForm> {
  bool ignorePage = true;
  TextEditingController otp = TextEditingController();
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> verifyMob() {
    return _networkLayer.authDio.post('/api/seller/verify/mob', data: {
      "code": otp.text,
      "mob":  Provider.of<AccountProvider>(context, listen: false).user?.mob ?? Provider.of<AccountProvider>(context, listen: false).phoneNumber
    });
  }

  Future<Response> resend() {
    return _networkLayer.authDio.post(
      '/api/seller/resend/mob1',
    );
  }

  Future<bool> resendCode() async {
    try {
      EasyLoading.show();

      return await resend().then((value) async {
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

  Future<bool> verify(String otp, String email) async {
    EasyLoading.show();
    try {
      return await verifyMob().then((value) async {
        EasyLoading.dismiss();
        print(value.statusCode);
        if (value.statusCode == 200) {
          print('condition 1');
          if (widget.showRoom) {
            moveBar();
            movePage();
          } else {
            await Provider.of<AccountProvider>(context, listen: false)
                .refresshUser(context)
                .then((value) async {
              print('condition 2');
              Seller? seller =
                  Provider.of<AccountProvider>(context, listen: false).user;
              if (seller != null && seller.hasShowroom) {
                print('condition 3');
                await (Provider.of<AccountProvider>(context, listen: false)
                    .loadCurrentPlan());
                FirebaseMessaging.instance.getToken().then((value) async {
                  debugPrint("getToken FCM $value");
                  await Provider.of<AccountProvider>(context, listen: false)
                      .setFcmToken(value!);
                });
                Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeScreen.ROUTE_NAME, (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    PreLoginScreen.ROUTE_NAME, (Route<dynamic> route) => false);
              }
            });
          }

          return Future.value(true);
        } else {
          print('error2');
          return Future.value(false);
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      print('error3');
      return Future.value(false);
    }
  }

  // @override
  // void dispose() {
  //   Provider.of<AccountProvider>(context, listen: false).setEmailSignup("");
  //   // TODO: implement dispose
  //   super.dispose();
  // }
  @override
  void deactivate() {
    Provider.of<AccountProvider>(context, listen: false).setEmailSignup("");

    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void initState() {
    Future.microtask(() {
      print(Provider.of<AccountProvider>(context, listen: false).emailSignUp);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Text(
            "Mobile Verification",
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "we have sent code to your mobile",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Center(
            child: PinPutCode(
              enabled: !ignorePage,
              controller: otp,
              onCompleted: (s) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                verify(
                        otp.text,
                    Provider.of<AccountProvider>(context, listen: false).user?.mob ??      Provider.of<AccountProvider>(context, listen: false)
                            .emailSignUp
                            .toString())
                    .then((value) async {
                  if (value) {
                  } else {
                    RevmoTheme.showRevmoSnackbar(
                        context, 'The selected code is invalid');
                    otp.clear();
                    print('error');
                  }
                });
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
                callBack: () {
                  if (otp.text.isNotEmpty && otp.text.length == 4) {
                    verify(
                            otp.text,
                            Provider.of<AccountProvider>(context, listen: false)
                                .emailSignUp
                                .toString())
                        .then((value) async {
                      if (value) {
                        Seller? loggedInUser =
                            await Provider.of<AccountProvider>(context,
                                    listen: false)
                                .refresshUser(
                          context,
                        );
                        if (loggedInUser is Seller) {
                          await Provider.of<AccountProvider>(context,
                                  listen: false)
                              .loadCurrentPlan();
                          // FirebaseMessaging.instance.getToken().then((value) async {
                          //   debugPrint("getToken FCM $value");
                          //   await Provider.of<AccountProvider>(context, listen: false)
                          //       .setFcmToken(value!);
                          // });
                          if (loggedInUser.hasShowroom)
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.ROUTE_NAME,
                              ModalRoute.withName('/'),
                            );
                          else
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                PreLoginScreen.ROUTE_NAME,
                                (Route<dynamic> route) => false);
                        }
                      } else {
                        RevmoTheme.showRevmoSnackbar(
                            context, 'The selected code is invalid');
                        otp.clear();
                        print('error');
                      }
                    });
                  } else {
                    RevmoTheme.showRevmoSnackbar(context, 'Please enter otp');
                  }
                },
              ),
              MainButton(
                text: "Resend code",
                width: double.infinity,
                color: RevmoColors.cyan.withOpacity(0.2),
                callBack: () {
                  // Navigator.pop(context);
                  resendCode();
                },
              )
            ],
          ),
        ]));
  }

  moveBar() {
    SignUpSteps.of(context).animationController.reset();
    SignUpSteps.of(context).barTween.begin = 1;
    SignUpSteps.of(context).barTween.end = 2;
    SignUpSteps.of(context).animationController.forward();
  }

  movePage() {
    SignUpSteps.of(context).formsController.animateToPage(2,
        duration: widget.animationsDuration, curve: widget.defaultCurve);
  }
}

//////////////

class VerficationFormCompany extends StatefulWidget {
  final Duration animationsDuration;
  final Curve defaultCurve;

  const VerficationFormCompany(
      {this.animationsDuration = const Duration(milliseconds: 500),
      this.defaultCurve = Curves.easeIn});

  @override
  _VerficationFormCompanyState createState() => _VerficationFormCompanyState();
}

class _VerficationFormCompanyState extends State<VerficationFormCompany> {
  bool ignorePage = true;
  TextEditingController otp = TextEditingController();
  final NetworkLayer _networkLayer = NetworkLayer();

  Future<Response> verifyEmail() {
    return _networkLayer.authDio.post('/api/seller/verify/email', data: {
      "code": otp.text,
      "mail": Provider.of<AccountProvider>(context, listen: false).emailSignUp
    });
  }

  Future<bool> verify(String otp, String email) async {
    EasyLoading.show();
    try {
      return await verifyEmail().then((value) async {
        EasyLoading.dismiss();
        print(value.statusCode);
        if (value.statusCode == 200) {
          print('condition 1');
          await Provider.of<AccountProvider>(context, listen: false)
              .refresshUser(context)
              .then((value) async {
            print('condition 2');
            Seller? seller =
                Provider.of<AccountProvider>(context, listen: false).user;
            if (seller != null && seller.hasShowroom) {
              print('condition 3');
              await (Provider.of<AccountProvider>(context, listen: false)
                  .loadCurrentPlan());
              FirebaseMessaging.instance.getToken().then((value) async {
                debugPrint("getToken FCM $value");
                await Provider.of<AccountProvider>(context, listen: false)
                    .setFcmToken(value!);
              });
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.ROUTE_NAME, (Route<dynamic> route) => false);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(PreLoginScreen.ROUTE_NAME);
            }
          });
          return Future.value(true);
        } else {
          print('error2');
          return Future.value(false);
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      print('error3');
      return Future.value(false);
    }
  }

  // @override
  // void dispose() {
  //   Provider.of<AccountProvider>(context, listen: false).setEmailSignup("");
  //   // TODO: implement dispose
  //   super.dispose();
  // }
  @override
  void deactivate() {
    Provider.of<AccountProvider>(context, listen: false).setEmailSignup("");

    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void initState() {
    Future.microtask(() {
      print(Provider.of<AccountProvider>(context, listen: false).emailSignUp);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          Text(
            "Email Verification",
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "we have sent code to you email",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Center(
            child: PinPutCode(
              enabled: !ignorePage,
              controller: otp,
              onCompleted: (s) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                verify(
                        otp.text,
                     Provider.of<AccountProvider>(context, listen: false)
                            .emailSignUp
                            .toString())
                    .then((value) async {
                  if (value) {
                  } else {
                    RevmoTheme.showRevmoSnackbar(
                        context, 'The selected code is invalid');
                    otp.clear();
                    print('error');
                  }
                });
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
                callBack: () {
                  if (otp.text.isNotEmpty && otp.text.length == 4) {
                    verify(
                            otp.text,
                            Provider.of<AccountProvider>(context, listen: false)
                                .emailSignUp
                                .toString())
                        .then((value) async {
                      if (value) {
                        Seller? loggedInUser =
                            await Provider.of<AccountProvider>(context,
                                    listen: false)
                                .refresshUser(
                          context,
                        );
                        if (loggedInUser is Seller) {
                          await Provider.of<AccountProvider>(context,
                                  listen: false)
                              .loadCurrentPlan();
                          // FirebaseMessaging.instance.getToken().then((value) async {
                          //   debugPrint("getToken FCM $value");
                          //   await Provider.of<AccountProvider>(context, listen: false)
                          //       .setFcmToken(value!);
                          // });
                          if (loggedInUser.hasShowroom)
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.ROUTE_NAME,
                              ModalRoute.withName('/'),
                            );
                          else
                            Navigator.of(context).pushReplacementNamed(
                                PreLoginScreen.ROUTE_NAME);
                        }
                      } else {
                        RevmoTheme.showRevmoSnackbar(
                            context, 'The selected code is invalid');
                        otp.clear();
                        print('error');
                      }
                    });
                  } else {
                    RevmoTheme.showRevmoSnackbar(context, 'Please enter otp');
                  }
                },
              ),
              MainButton(
                text: "Not now",
                width: double.infinity,
                color: RevmoColors.cyan.withOpacity(0.2),
                callBack: () {
                  // Navigator.pop(context);
                  Navigator.of(context)
                      .pushReplacementNamed(PreLoginScreen.ROUTE_NAME);
                },
              )
            ],
          ),
        ]));
  }
}
