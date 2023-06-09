import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/screens/auth/pre_login_screen.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/accounts/seller.dart';
import '../../providers/Seller/account_provider.dart';

class NewAccountCongratzScreen extends StatelessWidget {
  static const String ROUTE_NAME = "/congratz/screen";
  const NewAccountCongratzScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: RevmoColors.darkBlue.withOpacity(0.60),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 1, child: Container()),
            Flexible(flex: 3, child: Image(image: AssetImage(Paths.congratzPNG))),
            Flexible(flex: 2, child: FittedBox(child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.congratulations + "!", 3))),
            Flexible(
              flex: 1,
              child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  height: 60,
                  child: MainButton(
                    text: AppLocalizations.of(context)!.done,
                    width: double.infinity,
                    callBack: () async{
                      Seller? seller = Provider.of<AccountProvider>(context, listen: false).user;
                      if (seller != null && seller.hasShowroom) {
                        await (Provider.of<AccountProvider>(context, listen: false)
                            .loadCurrentPlan());
                        FirebaseMessaging.instance.getToken().then((value) async {
                          debugPrint("getToken FCM $value");
                          await Provider.of<AccountProvider>(context, listen: false)
                              .setFcmToken(value!);
                        });
                        Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
                      } else {
                        Navigator.of(context).pushReplacementNamed(PreLoginScreen.ROUTE_NAME);
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
