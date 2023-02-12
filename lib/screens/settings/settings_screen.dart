import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/screens/offers/offers_history.dart';
import 'package:revmo/screens/settings/account_screen.dart';
import 'package:revmo/screens/settings/contactus_screen.dart';
import 'package:revmo/screens/settings/subscriptions_screen.dart';
import 'package:revmo/screens/settings/team_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/shared/widgets/settings/settings_tile.dart';
import 'package:revmo/shared/widgets/settings/user_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/auth_service.dart';
import '../auth/pre_login_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/settings";
  const SettingsScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RevmoAppBar(),
      backgroundColor: RevmoColors.darkBlue,
      body: Consumer<AccountProvider>(builder: (context, sellerProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              sellerProvider.user != null ?
              UserCard(sellerProvider.user!) : SizedBox() ,
              SizedBox(
                height: 50,
              ),
              SettingsTile(
                text: AppLocalizations.of(context)!.home,
                icon: Paths.speedoLargeSVG,
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    PageTransition(child: HomeScreen(), type: PageTransitionType.rightToLeft), ModalRoute.withName('/')),
              ),
              SettingsTile(
                text: "Subscriptions",
                iconn: Icon(Iconsax.wallet_1),
                icon: Paths.speedoLargeSVG,
                onTap: () =>  Navigator.of(context).push(PageTransition(child: SubscriptionScreen(), type: PageTransitionType.rightToLeft)),

              ),
              // SettingsTile(
              //   text: AppLocalizations.of(context)!.offersHistory,
              //   icon: Paths.historySVG,
              //   onTap: () =>
              //       Navigator.of(context).push(PageTransition(child: OfferHistoryScreen(), type: PageTransitionType.rightToLeft)),
              // ),
              SettingsTile(
                text: AppLocalizations.of(context)!.account,
                icon: Paths.personSVG,
                onTap: () =>
                    Navigator.of(context).push(PageTransition(child: AccountScreen(), type: PageTransitionType.rightToLeft)),
              ),
              SettingsTile(
                text: AppLocalizations.of(context)!.team,
                icon: Paths.groupSVG,
                onTap: () =>
                    Navigator.of(context).push(PageTransition(child: TeamScreen(), type: PageTransitionType.rightToLeft)),
              ),
              SettingsTile(
                text: AppLocalizations.of(context)!.contactUs,
                icon: Paths.chatSVG,
                onTap: () => Navigator.of(context).push(PageTransition(child: ContactusScreen(), type: PageTransitionType.rightToLeft)),
              ),
              SettingsTile(
                text: AppLocalizations.of(context)!.logout,
                icon: Paths.logOutSVG,
                onTap: () async{
                          Navigator.of(context).pushNamedAndRemoveUntil(PreLoginScreen.ROUTE_NAME, (route) => false);
                          await AuthService.logOut(context);
                  // AppLocalizations.of(context)!.localeName = "ar";
        }
                ,
              ),
            ],
          ),
        );
      }),
    );
  }
}
