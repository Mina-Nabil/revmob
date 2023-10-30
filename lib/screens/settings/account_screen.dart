import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/screens/settings/edit_profile.dart';
import 'package:revmo/screens/settings/verify_account_credentials.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/UIwidgets/title_header.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/settings/user_card.dart';
import '../../shared/widgets/settings/user_image.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final sellerProvider = Provider.of<AccountProvider>(context);

    return Scaffold(
      backgroundColor: RevmoColors.darkBlue,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness:
              Platform.isIOS ? Brightness.light : Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: RevmoTheme.getTitle(AppLocalizations.of(context)!.account,
            color: RevmoColors.darkBlue),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfileView()));
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ))
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(30),
              width: double.infinity,
              // height: 300,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sellerProvider.user!.isEmailVerified == 0
                              ? Colors.red
                              : Colors.green),
                      // height: 20,
                      // width: 20,
                      child: sellerProvider.user!.isEmailVerified == 0
                          ? Icon(Icons.close)
                          : Icon(Icons.check),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 0.8,
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: UserImage(
                            sellerProvider.user!,
                            64,
                            fallbackTiInitials:
                                sellerProvider.user!.image == null
                                    ? true
                                    : false,
                          )),

                      // Center(child: UserCard(sellerProvider.user!)),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 25,
                        child: RevmoTheme.getTitle(
                            sellerProvider.user!.fullName,
                            color: RevmoColors.darkBlue),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (sellerProvider.user!.showroom != null)
                        SizedBox(
                          height: 25,
                          child: RevmoTheme.getCaption(
                              sellerProvider.user!.showroom!.fullName
                                  .toUpperCase(),
                              1,
                              color: RevmoColors.darkBlue),
                        ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: 3,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                                unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                              ),
                              Text(
                                ' |  3.0',
                                style: TextStyle(
                                    fontSize: 10, color: RevmoColors.darkBlue),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.timelapse_outlined,
                                color: RevmoColors.darkBlue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Very Responsive',
                                  style: TextStyle(color: RevmoColors.darkBlue))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),

            _dataInfo(
                title: AppLocalizations.of(context)!.fullName,
                info: sellerProvider.user!.fullName,
                icon: Icon(Iconsax.user)),
            sellerProvider.user!.email != ""
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _dataInfo(
                          title: "Email address",
                          info: sellerProvider.user!.email,
                          icon: Icon(Iconsax.mobile)),
                      if (sellerProvider.user!.isEmailVerified == false)
                        Row(
                          children: [
                            Text(
                                'Email is not verified please verify your email'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VerifyView(
                                                mail:
                                                    sellerProvider.user!.email,
                                              )));
                                },
                                child: Text('Verify now')),
                          ],
                        )
                    ],
                  )
                : SizedBox.shrink(),
            Column(
              children: [
                _dataInfo(
                    title: AppLocalizations.of(context)!.mobileNumber,
                    info: sellerProvider.user!.mob,
                    icon: Icon(Iconsax.mobile)),
                if (sellerProvider.user!.isMobVerified == false)
                  Row(
                    children: [
                      Text('Mobile is not verified please'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyView(
                                        phoneNumber: sellerProvider.user!.mob,
                                        )));
                          },
                          child: Text('Verify now')),
                    ],
                  )
              ],
            ),
            if (sellerProvider.user!.mob2.isNotEmpty)
              Column(
                children: [
                  _dataInfo(
                      title: "Secondary mobile number",
                      info: sellerProvider.user!.mob2,
                      icon: Icon(Iconsax.mobile)),
                  if (sellerProvider.user!.isMob2Verified == false)
                    Row(
                      children: [
                        Text('Number is not verified please'),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VerifyView(
                                            phoneNumber2: sellerProvider.user!.mob2,
                                          )));
                            },
                            child: Text('Verify now')),
                      ],
                    )
                ],
              ),

            SizedBox(
              height: 100,
            ),

            // sellerProvider.user!.mob2 != ""
            //     ? _dataInfo(
            //         title: "Mobile Num secondary",
            //         info: sellerProvider.user!.mob2,
            //         icon: Icon(Iconsax.mobile))
            //     : SizedBox.shrink(),
          ],
        ).setPageHorizontalPadding(context),
      ),
    );
  }
}

class _dataInfo extends StatelessWidget {
  final String title;
  final String info;
  final Widget icon;

  const _dataInfo(
      {Key? key, required this.title, required this.icon, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleHeader(
            title: title,
            color: Colors.white,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
            // width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(),
                  icon,
                  // Icon(Icons.copy_rounded)
                ]),
          ),
        ],
      ),
    );
  }
}
