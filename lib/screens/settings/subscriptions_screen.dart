import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/services/subscription_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/Subsriptions/plans.dart';
import '../../providers/Seller/account_provider.dart';
import '../../shared/colors.dart';
import '../../shared/widgets/misc/main_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  UserServiceNetworkLayer _service = UserServiceNetworkLayer();

  List<Plans>? subscriptions;

  Future? _plansFuture;

  Future? get plansFuture => _plansFuture;

  Future<bool> getPlans() async {
    try {
      return await _service.getSubscriptionPlans().then((value) {
        if (value.statusCode == 200 && value.data["message"] == "Success") {
          List<Plans> plansResponse = List<Plans>.from(
              value.data["body"]["plans"].map((x) => Plans.fromJson(x)));
          setState(() {
            subscriptions = plansResponse;
          });
          return Future.value(true);
        } else {
          setState(() {
            subscriptions = [];
          });
          return Future.value(false);
        }
      });
    } catch (e) {
      setState(() {
        subscriptions = [];
      });
      return Future.value(false);
    }
  }

  Future<bool> subscribe(String planId, String type, String days, String amount,
      String transactionId) async {
    try {
      return await _service
          .subscribe(planId, type, days, amount, transactionId)
          .then((value) {
        if (value.statusCode == 200 && value.data["message"] == "Success") {
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  List<int> ids = [];
  List<Plans> idss = [];

  void addIdss(
    Plans plans,
  ) {
    if (idss.any((element) => element.id == plans.id) ||
        plans.selected == true) {
      print("condition 1  ${idss.first.id}");
      removeFromCompareList(plans.id!);
      setState(() {
        plans.selected = false;
      });
    } else {
      if (idss.length >= 1) {
        setState(() {
          idss.first.selected = false;
          plans.selected = true;
        });
        idss.clear();
        idss.add(plans);
        print("condition 2 ${idss.first.id}");
      } else {
        setState(() {
          plans.selected = true;
        });
        idss.add(plans);
        print("condition 3  ${idss.first.id}");
        setState(() {});
      }
    }
  }

  removeFromCompareList(int id) {
    idss.removeWhere((data) {
      return data.id == id;
    });
  }

  @override
  void initState() {
    setState(() {
      _plansFuture = getPlans().then((value) {
        if (value) {
          // setState(() {
          //   idss.add(subscriptions![0]);
          //   subscriptions![0].selected = true;
          // });
        }
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AccountProvider>(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: RevmoColors.darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.subscriptions),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            provider.plans == null
                ? noInternetWidget(
                    onPressed: () async {
                      await Provider.of<AccountProvider>(context, listen: false)
                          .loadCurrentPlan();
                    },
                  )
                : provider.plans!.id == 2 || provider.plans!.id == 3
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: mediaQuery.size.width,
                            // height: 200,
                            decoration: BoxDecoration(
                                color: Color(0xffFFFB100),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${provider.plans!.name!} ${AppLocalizations.of(context)!.isActivated}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    provider.plans!.name == "Business PLan"
                                        ? Lottie.asset(
                                            "assets/images/premium.json",
                                            height: 50,
                                          )
                                        : Lottie.asset("assets/images/pro.json",
                                            height: 40)
                                  ],
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.egCurrency} ${provider.plans!.monthlyPrice!} ${AppLocalizations.of(context)!.perMonth}",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppLocalizations.of(context)!.whatYouGet,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              OptionContainer(
                                title:     AppLocalizations.of(context)!
                                    .ultraFastConnection,
                                icon: Icon(Iconsax.speedometer5),
                              ),
                              OptionContainer(
                                title: AppLocalizations.of(context)!
                                    .registrationUpTo10ShowRooms,
                                icon: Icon(Iconsax.shop),
                              ),
                              OptionContainer(
                                title:     AppLocalizations.of(context)!
                                    .addFreeExperience,
                                icon:      Icon(Iconsax.lock),
                              ),
                              OptionContainer(
                                title:    AppLocalizations.of(context)!
                                    .ultraFastConnection,
                                icon:       Icon(Iconsax.people),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            title:
                                Text(AppLocalizations.of(context)!.offersLimit),
                            subtitle: Text(AppLocalizations.of(context)!
                                .offersLimitDescription),
                            trailing: Text.rich(TextSpan(
                                text: provider.currentPlan!.offers.toString(),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: " / ${provider.plans!.offersLimit}"
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 33,
                                        fontWeight: FontWeight.bold),
                                  )
                                ])),
                          ),
                          AppLocalizations.of(context)!.localeName == "ar"
                              ? SizedBox(
                                  height: 5,
                                )
                              : SizedBox.shrink(),
                          ListTile(
                            title:
                                Text(AppLocalizations.of(context)!.usersLimit),
                            subtitle: Text(
                              AppLocalizations.of(context)!
                                  .usersLimitDescription,
                            ),
                            trailing: Text.rich(TextSpan(
                                text: provider.currentPlan!.users.toString(),
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: " / ${provider.plans!.usersLimit}"
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 33,
                                        fontWeight: FontWeight.bold),
                                  )
                                ])),
                          ),
                          AppLocalizations.of(context)!.localeName == "ar"
                              ? SizedBox(
                                  height: 5,
                                )
                              : SizedBox.shrink(),
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.emailSupport,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)!
                                  .emailSupportDescription,
                            ),
                            trailing: checkBox(
                                selected: provider.plans!.emailSupport == 0
                                    ? false
                                    : true),
                          ),
                          AppLocalizations.of(context)!.localeName == "ar"
                              ? SizedBox(
                                  height: 5,
                                )
                              : SizedBox.shrink(),
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.chatSupport,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)!
                                  .chatSupportDescription,
                            ),
                            trailing: checkBox(
                                selected: provider.plans!.emailSupport == 0
                                    ? false
                                    : true),
                          ),
                          AppLocalizations.of(context)!.localeName == "ar"
                              ? SizedBox(
                                  height: 5,
                                )
                              : SizedBox.shrink(),
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.phoneSupport,
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)!
                                  .phoneSupportDescription,
                            ),
                            trailing: checkBox(
                                selected: provider.plans!.phoneSupport == 0
                                    ? false
                                    : true),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            // height: 100,
                            width: mediaQuery.size.width,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.monthly,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 20,
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.egCurrency}${provider.plans!.monthlyPrice!}${AppLocalizations.of(context)!.perMonth}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.blueGrey.withOpacity(0.3),
                                      ),
                                      onPressed: () {},
                                      child: SizedBox(
                                          width: mediaQuery.size.width,
                                          child: Center(
                                              child: Text(
                                                  AppLocalizations.of(context)!
                                                      .cancelSubscription)))),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      )
                    : FutureBuilder(
                        future: _plansFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError == true) {
                              print('condition2');

                              return Center(
                                  child: Text(
                                'Oops.. Something went wrong !',
                                style: TextStyle(color: Colors.grey),
                              ));
                            }
                            // else if (subscriptions!.isEmpty) {
                            //   return FadeInUp(
                            //     child: Center(
                            //       child: Text('empty'),
                            //       // fetchCustomers
                            //     ),
                            //   );
                            // }

                            else {
                              print('condition1');

                              return Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                  ),
                                  FadeIn(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .upgradetopremiumtounlockadditionalfeatures,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: mediaQuery.size.width,
                                    child: FadeInUp(
                                      delay: Duration(milliseconds: 400),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          OptionContainer(
                                            title:     AppLocalizations.of(context)!
                                                .ultraFastConnection,
                                            icon: Icon(Iconsax.speedometer5),
                                          ),
                                          OptionContainer(
                                            title: AppLocalizations.of(context)!
                                                .registrationUpTo10ShowRooms,
                                            icon: Icon(Iconsax.shop),
                                          ),
                                          OptionContainer(
                                            title:     AppLocalizations.of(context)!
                                                .addFreeExperience,
                                            icon:      Icon(Iconsax.lock),
                                          ),
                                          OptionContainer(
                                            title:    AppLocalizations.of(context)!
                                                .ultraFastConnection,
                                            icon:       Icon(Iconsax.people),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ListView.separated(
                                    itemBuilder: (context, index) {
                                      var selected =
                                          subscriptions![index].selected;
                                      return FadeInUp(
                                        delay: Duration(milliseconds: 500),
                                        child: InkWell(
                                          onTap: () {
                                            addIdss(subscriptions![index]);
                                          },
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 700),
                                            // height: mediaQuery.size.height * 0.3,
                                            width: mediaQuery.size.width,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                color: selected!
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: selected ? 1 : 0.35),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      subscriptions![index]
                                                          .name!,
                                                      style: TextStyle(
                                                          color: selected
                                                              ? RevmoColors
                                                                  .darkBlue
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    subscriptions![index]
                                                                .name ==
                                                            "Business Plan"
                                                        ? Lottie.asset(
                                                            "assets/images/premium.json",
                                                            height: 40)
                                                        : subscriptions![index]
                                                                    .name ==
                                                                "Pro Plan"
                                                            ? Lottie.asset(
                                                                "assets/images/pro.json",
                                                                height: 40)
                                                            : SizedBox(),
                                                  ],
                                                ),

                                                !selected
                                                    ? subscriptions![index]
                                                                .name ==
                                                            "Free Plan"
                                                        ? SizedBox.shrink()
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '${AppLocalizations.of(context)!.egCurrency} ${subscriptions![index].monthlyPrice}/per month'),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  '${AppLocalizations.of(context)!.egCurrency} ${subscriptions![index].annualPrice}/per year'),
                                                            ],
                                                          )
                                                    : SizedBox.shrink(),
                                                selected
                                                    ? Divider(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                      )
                                                    : SizedBox.shrink(),
                                                // SizedBox(
                                                //   width: 100,
                                                //   child: MaterialButton(
                                                //       padding: EdgeInsets.all(5),
                                                //       onPressed: () {},
                                                //       child: Row(
                                                //         children: [
                                                //           Text(
                                                //             'View Details',
                                                //             style: TextStyle(
                                                //                 color: selected ? Colors.white : RevmoColors.darkBlue),
                                                //           ),
                                                //           SizedBox(
                                                //             width: 5,
                                                //           ),
                                                //           Icon(
                                                //             Icons.arrow_forward,
                                                //             color: RevmoColors.darkBlue,
                                                //             size: 15,
                                                //           ),
                                                //         ],
                                                //       )),
                                                // ),
                                                selected
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          subscriptions![index]
                                                                      .name ==
                                                                  "Free Plan"
                                                              ? SizedBox
                                                                  .shrink()
                                                              : Center(
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .pricing,
                                                                    style: TextStyle(
                                                                        color: selected
                                                                            ? RevmoColors
                                                                                .darkBlue
                                                                            : Colors
                                                                                .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                ),
                                                          subscriptions![index]
                                                                      .name ==
                                                                  "Free Plan"
                                                              ? SizedBox
                                                                  .shrink()
                                                              : SizedBox(
                                                                  height: 8,
                                                                ),
                                                          subscriptions![index]
                                                                      .name ==
                                                                  "Free Plan"
                                                              ? SizedBox
                                                                  .shrink()
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          " ${subscriptions![index].monthlyPrice.toString()} ${AppLocalizations.of(context)!.egCurrency}",
                                                                          style: TextStyle(
                                                                              color: selected ? RevmoColors.darkBlue : Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                        Text(
                                                                          AppLocalizations.of(context)!
                                                                              .perMonth,
                                                                          style: TextStyle(
                                                                              color: selected ? RevmoColors.darkBlue : Colors.white,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          " ${subscriptions![index].annualPrice.toString()} ${AppLocalizations.of(context)!.egCurrency}",
                                                                          style: TextStyle(
                                                                              color: selected ? RevmoColors.darkBlue : Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20),
                                                                        ),
                                                                        Text(
                                                                          AppLocalizations.of(context)!
                                                                              .perYear,
                                                                          style: TextStyle(
                                                                              color: selected ? RevmoColors.darkBlue : Colors.white,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 14),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                          subscriptions![index]
                                                                      .name ==
                                                                  "Free Plan"
                                                              ? SizedBox
                                                                  .shrink()
                                                              : SizedBox(
                                                                  height: 8,
                                                                ),
                                                          subscriptions![index]
                                                                      .name ==
                                                                  "Free Plan"
                                                              ? SizedBox
                                                                  .shrink()
                                                              : Divider(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                ),
                                                          PricingContainer(
                                                            selected: selected,
                                                            title: AppLocalizations
                                                                    .of(context)!
                                                                .offersLimit,
                                                            icon: Icon(
                                                              Iconsax
                                                                  .money_time5,
                                                              color: RevmoColors
                                                                  .darkBlue,
                                                            ),
                                                            info:
                                                                subscriptions![
                                                                        index]
                                                                    .offersLimit
                                                                    .toString(),
                                                          ),
                                                          PricingContainer(
                                                            selected: selected,
                                                            info:
                                                                subscriptions![
                                                                        index]
                                                                    .usersLimit
                                                                    .toString(),
                                                            title: AppLocalizations
                                                                    .of(context)!
                                                                .usersLimit,
                                                            icon: Icon(
                                                              Iconsax.people5,
                                                              color: RevmoColors
                                                                  .darkBlue,
                                                            ),
                                                            // widget: checkBox(
                                                            //     selected: subscriptions![
                                                            //     index]
                                                            //         .usersLimit ==
                                                            //         0
                                                            //         ? false
                                                            //         : true),
                                                          ),
                                                          PricingContainer(
                                                            selected: selected,
                                                            info: "",
                                                            title: AppLocalizations
                                                                    .of(context)!
                                                                .emailSupport,
                                                            icon: Icon(
                                                              Iconsax.message5,
                                                              color: RevmoColors
                                                                  .darkBlue,
                                                            ),
                                                            widget: checkBox(
                                                                selected:
                                                                    subscriptions![index].emailSupport ==
                                                                            0
                                                                        ? false
                                                                        : true),
                                                          ),
                                                          PricingContainer(
                                                            selected: selected,
                                                            info: "",
                                                            icon: Icon(
                                                              Iconsax.support5,
                                                              color: RevmoColors
                                                                  .darkBlue,
                                                            ),
                                                            title: AppLocalizations
                                                                    .of(context)!
                                                                .chatSupport,
                                                            widget: checkBox(
                                                                selected:
                                                                    subscriptions![index].chatSupport ==
                                                                            0
                                                                        ? false
                                                                        : true),
                                                          ),
                                                          PricingContainer(
                                                            selected: selected,
                                                            info: "",
                                                            icon: Icon(
                                                              Iconsax.call5,
                                                              color: RevmoColors
                                                                  .darkBlue,
                                                            ),
                                                            title: AppLocalizations
                                                                    .of(context)!
                                                                .phoneSupport,
                                                            widget: checkBox(
                                                                selected:
                                                                    subscriptions![index].phoneSupport ==
                                                                            0
                                                                        ? false
                                                                        : true),
                                                          ),
                                                          subscriptions![index]
                                                                      .name ==
                                                                  "Free Plan"
                                                              ? SizedBox
                                                                  .shrink()
                                                              : Divider(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.3),
                                                                ),
                                                          subscriptions![index]
                                                                      .name ==
                                                                  "Free Plan"
                                                              ? SizedBox
                                                                  .shrink()
                                                              : Center(
                                                                  child:
                                                                      MainButton(
                                                                    color: RevmoColors
                                                                        .originalBlue,
                                                                    callBack:
                                                                        () {
                                                                      showCupertinoModalBottomSheet(
                                                                        expand:
                                                                            false,
                                                                        context:
                                                                            context,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        useRootNavigator:
                                                                            true,
                                                                        builder:
                                                                            (context) =>
                                                                                Container(
                                                                          color:
                                                                              Colors.white,
                                                                          height:
                                                                              mediaQuery.size.height * 0.4,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Text(
                                                                                AppLocalizations.of(context)!.subscribe,
                                                                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Material(
                                                                                color: Colors.transparent,
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    EasyLoading.show();
                                                                                    provider.subscribe(subscriptions![index].id!.toString(), "paid", "30", subscriptions![index].monthlyPrice.toString(), "transactionId-1").then((value) {
                                                                                      EasyLoading.dismiss();

                                                                                      if (value) {
                                                                                        Navigator.pop(context);
                                                                                      }
                                                                                    });
                                                                                  },
                                                                                  child: Container(
                                                                                    width: mediaQuery.size.width,
                                                                                    height: mediaQuery.size.height * 0.08,
                                                                                    decoration: BoxDecoration(
                                                                                      color: RevmoColors.originalBlue,
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                    ),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          AppLocalizations.of(context)!.subscribeToMonthlyPlan,
                                                                                          style: TextStyle(fontSize: 14),
                                                                                        ),
                                                                                        Text(
                                                                                          " ${subscriptions![index].monthlyPrice.toString()} ${AppLocalizations.of(context)!.egCurrency}",
                                                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Divider(
                                                                                color: Colors.black.withOpacity(0.3),
                                                                                height: 20,
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  EasyLoading.show();

                                                                                  provider.subscribe(subscriptions![index].id!.toString(), "paid", "365", subscriptions![index].annualPrice.toString(), "transactionId-2").then((value) {
                                                                                    EasyLoading.dismiss();

                                                                                    if (value) {
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  width: mediaQuery.size.width,
                                                                                  height: mediaQuery.size.height * 0.08,
                                                                                  decoration: BoxDecoration(
                                                                                    color: RevmoColors.originalBlue,
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                  ),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        AppLocalizations.of(context)!.subscribeToAnnualPlan,
                                                                                        style: TextStyle(fontSize: 14),
                                                                                      ),
                                                                                      Text(
                                                                                        " ${subscriptions![index].annualPrice.toString()} ${AppLocalizations.of(context)!.egCurrency}",
                                                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text(
                                                                                    AppLocalizations.of(context)!.back,
                                                                                  ))
                                                                            ],
                                                                          ).setPageHorizontalPadding(context),
                                                                        ),
                                                                      );
                                                                      // provider.subscribe(
                                                                      //     subscriptions![index].id!
                                                                      //         .toString(),
                                                                      //   "paid",
                                                                      //     subscriptions![index]., subscriptions![index].id!.toString(),
                                                                      //     subscriptions![index].id!.toString());
                                                                    },
                                                                    text: AppLocalizations.of(
                                                                            context)!
                                                                        .subscribeNow,
                                                                  ),
                                                                ),
                                                        ],
                                                      )
                                                    : SizedBox.shrink()
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 15,
                                      );
                                    },
                                    itemCount: subscriptions!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  FadeInUp(
                                    delay: Duration(milliseconds: 600),
                                    child: Text(
                                        'By purchasing a subscription, you agree to the Terms of service and Privacy policy. You can cancel anytime. Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase. Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription.'),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                ],
                              );
                            }
                          } else {
                            print('condition3');

                            return Container(
                                height: mediaQuery.size.height * 0.7,
                                child:
                                    Center(child: CircularProgressIndicator()));
                            //   ListView.separated(
                            //   shrinkWrap: true,
                            //   physics: NeverScrollableScrollPhysics(),
                            //   itemCount: 3,
                            //   itemBuilder: (context, index) => FadeInUp(
                            //       duration: Duration(milliseconds: 300),
                            //       child: CustomTileLoadingWidget()),
                            //   separatorBuilder: (BuildContext context, int index) {
                            //     return SizedBox(
                            //       height: 20,
                            //     );
                            //   },
                            // );
                          }
                        },
                      ),
          ],
        ).setPageHorizontalPadding(context),
      ),
    );
  }
}

class OptionContainer extends StatelessWidget {
  final String title;
  final Widget icon;

  const OptionContainer({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        // Icon(Iconsax.shop),
        SizedBox(
          height: 3,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            title,
            // AppLocalizations.of(context)!.registrationUpTo10ShowRooms,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class noInternetWidget extends StatelessWidget {
  const noInternetWidget({Key? key, required this.onPressed}) : super(key: key);
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 170,
        ),
        Lottie.asset('assets/images/disconnect.json',
            repeat: true, height: 200, frameRate: FrameRate.composition),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Oops! Can't move forward",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.badInternet,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            AppLocalizations.of(context)!.again,
          ),
        )
      ],
    ));
  }
}

class checkBox extends StatelessWidget {
  const checkBox({
    Key? key,
    required this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: selected ? const Color(0xff167A5D) : Colors.transparent,
          border: selected
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Icon(
          Icons.check,
          color: selected == false ? Colors.grey : Colors.white,
          size: 15,
        ),
      ),
    );
  }
}

class PricingContainer extends StatelessWidget {
  const PricingContainer(
      {Key? key,
      required this.selected,
      required this.title,
      required this.info,
      this.widget,
      this.icon})
      : super(key: key);

  final bool selected;
  final String title;
  final String info;
  final Widget? widget;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) icon!,
              if (icon != null)
                SizedBox(
                  width: 4,
                ),
              Text(
                title,
                style: TextStyle(
                    color: selected ? RevmoColors.darkBlue : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          widget != null
              ? widget!
              : info == "-1"
                  ? Icon(
                      Iconsax.unlimited,
                      color: RevmoColors.darkBlue,
                    )
                  : Text(
                      info,
                      // "${subscriptions![index]
                      //      .annualPrice!
                      //      .toString()} EGP",
                      style: TextStyle(
                          color: selected ? RevmoColors.darkBlue : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
        ],
      ),
    );
  }
}
