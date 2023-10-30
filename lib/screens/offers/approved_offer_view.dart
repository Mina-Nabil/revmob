import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/screens/offers/Extras/extras_view.dart';
import 'package:revmo/screens/offers/RequestDocuments/request_documents_view.dart';

import '../../models/offers/offer.dart';
import '../../shared/colors.dart';
import 'Calendar/calendar_view.dart';
import 'approved_offer_detail.dart';

class AcceptedOfferView extends StatefulWidget {
  const AcceptedOfferView({Key? key, required this.offer}) : super(key: key);
  final Offer offer;

  @override
  State<AcceptedOfferView> createState() => _AcceptedOfferViewState();
}

class _AcceptedOfferViewState extends State<AcceptedOfferView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: RevmoColors.darkBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: RevmoColors.darkBlue,
        title: Text(widget.offer.car.carName),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            TileContainer(
              onTap: () {
                print('hello');
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            color: RevmoColors.darkBlue,
                            size: 40,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.offer.buyer.fullName,
                                    style: const TextStyle(
                                        color: RevmoColors.darkBlue),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Icon(
                                    Icons.check_circle_sharp,
                                    color: RevmoColors.originalBlue,
                                    size: 10,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                // ${widget.offer.showroom!.shrmName!}
                                "Communicate with Buyer",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                Iconsax.message,
                                color: RevmoColors.darkBlue,
                              ),
                              Positioned(
                                top: -10,
                                right: -5,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),
                                  child: Text(
                                    '1',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                AnimatedContainer(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  // height: 227,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 10,
                        ),
                      ]),
                  duration: const Duration(milliseconds: 10000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // OfferTopWidget(
                      //   offer: widget.offer,
                      //   isDetail: true,
                      //   negotiate: true,
                      // ),
                      // const CustomDivider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Offers Details',
                                style: const TextStyle(
                                    color: RevmoColors.darkBlue,
                                    fontFamily: 'Gibson',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ApprovedOfferDetail(
                                                  offerFromApproved:
                                                      widget.offer,
                                                )));
                                  },
                                  child: Text("Show Details")),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          if (expanded)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 3,
                                          decoration: const BoxDecoration(
                                              color: RevmoColors.originalBlue),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        // _TitleValue(
                                        //   title: 'offers.totalPrice'.tr(),
                                        //   value: widget.offer.offrPrce!
                                        //       .formatPrice(),
                                        // ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 45,
                                          width: 3,
                                          decoration: BoxDecoration(
                                              color: RevmoColors.originalBlue),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        // _TitleValue(
                                        //   title: 'offers.minPayment'.tr(),
                                        //   value: widget.offer.offrMinPymt!
                                        //       .formatPrice(),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TileContainer(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestDocuments(
                                offer: widget.offer,
                              )));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Iconsax.document,
                          color: RevmoColors.darkBlue,
                          size: 35,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Request Documents",
                              style: TextStyle(color: RevmoColors.darkBlue),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Request nessecary Documents needed from buyer",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            TileContainer(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarPage(
                                offer: widget.offer,
                              )));
                  print("hello");
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.calendar5,
                          color: RevmoColors.darkBlue,
                          size: 35,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Calendar",
                              style: TextStyle(color: RevmoColors.darkBlue),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Check or add events shared with the buyer",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            TileContainer(
                onTap: () {
                  print("hello");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Extras(offer: widget.offer)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Iconsax.box,
                          color: RevmoColors.darkBlue,
                          size: 35,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Extras",
                              style: TextStyle(color: RevmoColors.darkBlue),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Car Accessories",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            const SizedBox(
              height: 50,
            ),
          ],
        ).setPageHorizontalPadding(context),
      ),
    );
  }
}

class TileContainer extends StatelessWidget {
  final Widget child;
  final Function() onTap;

  const TileContainer({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 10,
              ),
            ]),
        child: child,
      ),
    );
  }
}
