import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/services/subscription_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/Subsriptions/plans.dart';
import '../../shared/colors.dart';
import '../../shared/widgets/misc/main_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionService _service = SubscriptionService();

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
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: RevmoColors.darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Subscriptions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _plansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
                            'Upgrade to premium to unlock \nadditional features',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FadeInUp(
                          delay: Duration(milliseconds: 400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Iconsax.speedometer5),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Ultra-Fast\n Connection',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Iconsax.shop),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Registration up\nto 10 showRooms',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Iconsax.lock),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Add-free\nexperience',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(Iconsax.people),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'Access up\n to 10 users',
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.separated(
                          itemBuilder: (context, index) {
                            var selected = subscriptions![index].selected;
                            return FadeInUp(
                              delay: Duration(milliseconds: 500),

                              child: InkWell(
                                onTap: () {
                                  addIdss(subscriptions![index]);
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 700),
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
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            subscriptions![index].name!,
                                            style: TextStyle(
                                                color: selected
                                                    ? RevmoColors.darkBlue
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          subscriptions![index].name ==
                                                  "Business Plan"
                                              ? Lottie.asset(
                                                  "assets/images/premium.json",
                                                  height: 40)
                                              : subscriptions![index].name ==
                                                      "Pro Plan"
                                                  ? Lottie.asset(
                                                      "assets/images/pro.json",
                                                      height: 40)
                                                  : SizedBox(),
                                        ],
                                      ),

                                      !selected
                                          ? subscriptions![index].name ==
                                                  "Free Plan"
                                              ? SizedBox.shrink()
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'EGP ${subscriptions![index].monthlyPrice}/per month'),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        'EGP ${subscriptions![index].annualPrice}/per year'),
                                                  ],
                                                )
                                          : SizedBox.shrink(),
                                      selected
                                          ? Divider(
                                              color:
                                                  Colors.black.withOpacity(0.3),
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
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                subscriptions![index].name ==
                                                        "Free Plan"
                                                    ? SizedBox.shrink()
                                                    : Center(
                                                        child: Text(
                                                          "Pricing",
                                                          style: TextStyle(
                                                              color: selected
                                                                  ? RevmoColors
                                                                      .darkBlue
                                                                  : Colors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                subscriptions![index].name ==
                                                        "Free Plan"
                                                    ? SizedBox.shrink()
                                                    : SizedBox(
                                                        height: 8,
                                                      ),
                                                subscriptions![index].name ==
                                                        "Free Plan"
                                                    ? SizedBox.shrink()
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
                                                                    color: selected
                                                                        ? RevmoColors
                                                                            .darkBlue
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                "per month",
                                                                style: TextStyle(
                                                                    color: selected
                                                                        ? RevmoColors
                                                                            .darkBlue
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14),
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
                                                                    color: selected
                                                                        ? RevmoColors
                                                                            .darkBlue
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                "per year",
                                                                style: TextStyle(
                                                                    color: selected
                                                                        ? RevmoColors
                                                                            .darkBlue
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                subscriptions![index].name ==
                                                        "Free Plan"
                                                    ? SizedBox.shrink()
                                                    : SizedBox(
                                                        height: 8,
                                                      ),
                                                subscriptions![index].name ==
                                                        "Free Plan"
                                                    ? SizedBox.shrink()
                                                    : Divider(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                      ),
                                                PricingContainer(
                                                  selected: selected,
                                                  title: "Offers Limit",
                                                  icon: Icon(
                                                    Iconsax.money_time5,
                                                    color: RevmoColors.darkBlue,
                                                  ),
                                                  info: subscriptions![index]
                                                      .offersLimit
                                                      .toString(),
                                                ),
                                                PricingContainer(
                                                  selected: selected,
                                                  info: subscriptions![index]
                                                      .usersLimit
                                                      .toString(),
                                                  title: "Users Limit",
                                                  icon: Icon(
                                                    Iconsax.people5,
                                                    color: RevmoColors.darkBlue,
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
                                                  title: "Email Support",
                                                  icon: Icon(
                                                    Iconsax.message5,
                                                    color: RevmoColors.darkBlue,
                                                  ),
                                                  widget: checkBox(
                                                      selected: subscriptions![
                                                                      index]
                                                                  .emailSupport ==
                                                              0
                                                          ? false
                                                          : true),
                                                ),
                                                PricingContainer(
                                                  selected: selected,
                                                  info: "",
                                                  icon: Icon(
                                                    Iconsax.support5,
                                                    color: RevmoColors.darkBlue,
                                                  ),
                                                  title: "Chat Support",
                                                  widget: checkBox(
                                                      selected: subscriptions![
                                                                      index]
                                                                  .chatSupport ==
                                                              0
                                                          ? false
                                                          : true),
                                                ),
                                                PricingContainer(
                                                  selected: selected,
                                                  info: "",
                                                  icon: Icon(
                                                    Iconsax.call5,
                                                    color: RevmoColors.darkBlue,
                                                  ),
                                                  title: "Phone Support",
                                                  widget: checkBox(
                                                      selected: subscriptions![
                                                                      index]
                                                                  .phoneSupport ==
                                                              0
                                                          ? false
                                                          : true),
                                                ),
                                                subscriptions![index].name ==
                                                        "Free Plan"
                                                    ? SizedBox.shrink()
                                                    : Divider(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                      ),
                                                subscriptions![index].name ==
                                                        "Free Plan"
                                                    ? SizedBox.shrink()
                                                    : Center(
                                                        child: MainButton(
                                                          color: RevmoColors
                                                              .originalBlue,
                                                          callBack: () {},
                                                          text: "Subscribe now",
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
                      child: Center(child: CircularProgressIndicator()));
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
              :
          info == "-1"
              ? Icon(Iconsax.unlimited,color: RevmoColors.darkBlue,)
              :
          Text(
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
