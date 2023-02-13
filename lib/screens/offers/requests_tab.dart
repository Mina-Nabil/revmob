import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/offers_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/default_header.dart';
import 'package:revmo/shared/widgets/misc/not_found_widget.dart';
import 'package:revmo/shared/widgets/misc/titles_row.dart';
import 'package:revmo/shared/widgets/offers/Requests/offer_approved_tile.dart';
import 'package:revmo/shared/widgets/offers/offer_tile.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import '../../shared/widgets/misc/main_button.dart';
import 'package:revmo/shared/widgets/offers/Requests/requests.dart';

import '../../shared/widgets/UIwidgets/success_message.dart';

class RequestsTab extends StatefulWidget {
  static const String screenName = "requestsTab";

  const RequestsTab();

  @override
  _RequestsTabState createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  int currentPage = 0;
  bool isLoading = true;
  final TextEditingController _searchTextController =
      new TextEditingController();
  PageController _pageController = new PageController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<OffersProvider>(context, listen: false)
          .loadOfferRequests();
      await Provider.of<OffersProvider>(context, listen: false)
          .loadPendingOffersNetworkLayer();
      await Provider.of<OffersProvider>(context, listen: false)
          .loadApprovedOffersNetworkLayer();
      await Provider.of<OffersProvider>(context, listen: false)
          .loadExpiredOffersNetworkLayer();
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //tab title
                ...[
                  SizedBox(
                    height: 5,
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   child: RevmoTheme.getSemiBold(
                  //       AppLocalizations.of(context)!.requests, 3),
                  // ),
                  Container(
                    child: Text(
                      AppLocalizations.of(context)!.requests,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],

                //search, filters & titles
                ...[
                  RevmoDefaultHeader(
                    searchCallback: searchRequests,
                    searchTextController: _searchTextController,
                    hideFilterbutton: true,
                    hideSortbutton: true,
                    filterCallback: setFilters,
                    sortCallback: sortRequests,
                  ),
                  TitlesRow(
                    {
                      AppLocalizations.of(context)!.newRequests: () {
                        setState(() {
                          currentPage = 0;
                        });
                        _pageController.jumpToPage(0);
                      },
                      AppLocalizations.of(context)!.pending: () {
                        setState(() {
                          currentPage = 1;
                        });
                        _pageController.jumpToPage(1);
                      },
                      AppLocalizations.of(context)!.approved: () {
                        setState(() {
                          currentPage = 2;
                        });
                        _pageController.jumpToPage(2);
                      },
                      AppLocalizations.of(context)!.expired: () {
                        setState(() {
                          currentPage = 3;
                        });
                        _pageController.jumpToPage(3);
                      },
                    },
                    currentPage,
                    subtitles: [
                      " (" +
                          Provider.of<OffersProvider>(context)
                              .newRequests
                              .length
                              .toString() +
                          ")",
                      " (" +
                          Provider.of<OffersProvider>(context)
                              .pending
                              .length
                              .toString() +
                          ")",
                      " (" +
                          Provider.of<OffersProvider>(context)
                              .approved
                              .length
                              .toString() +
                          ")",
                      " (" +
                          Provider.of<OffersProvider>(context)
                              .expired
                              .length
                              .toString() +
                          ")",
                    ],
                  ),
                ],
                Expanded(
                  child: (isLoading)
                      ? Center(child: CircularProgressIndicator())
                      : Consumer<OffersProvider>(
                          builder: (cnxt, offersProvider, _) => PageView(
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: _pageController,
                            children: [
                              ///NEW OFFERS
                              RefreshIndicator(
                                onRefresh: refreshNewRequests,
                                child: offersProvider.displayedNew.length > 0
                                    ? ListView.builder(
                                        padding: EdgeInsets.only(bottom: 25),
                                        shrinkWrap: true,
                                        itemCount:
                                            offersProvider.displayedNew.length,
                                        itemBuilder: (cnxt, i) {
                                          // print(offersProvider
                                          //     .newRequests.length);
                                          return FadeInUp(
                                            child: OfferTile.request(
                                                offersProvider.displayedNew[i]),
                                          );
                                        })
                                    : NotFoundWidget.offers(),
                              ),

                              ///PENDING OFFERS
                              RefreshIndicator(
                                  onRefresh: refreshPendingRequests,
                                  child: offersProvider
                                              .displayedPending.length >
                                          0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            AppLocalizations.of(context)!
                                                        .localeName ==
                                                    "en"
                                                ? FadeInRight(
                                                    child: MainButton(
                                                        width: 200,
                                                        text:
                                                            // 'EXTEND ALL OFFERS FOR 2 DAYS',
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .extendAllOffers2days,
                                                        callBack: () {
                                                          extendAllOffers();
                                                        }),
                                                  )
                                                : FadeInLeft(
                                                    child: MainButton(
                                                        width: 200,
                                                        text:
                                                            // 'EXTEND ALL OFFERS FOR 2 DAYS',
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .extendAllOffers2days,
                                                        callBack: () {
                                                          extendAllOffers();
                                                        }),
                                                  ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              child: ListView.separated(
                                                padding:
                                                    EdgeInsets.only(bottom: 20),
                                                shrinkWrap: true,
                                                itemCount: offersProvider
                                                    .displayedPending.length,
                                                itemBuilder: (cnxt, i) {
                                                  return FadeInUp(
                                                      duration: Duration(
                                                          milliseconds: 200),
                                                      child: PendingRequestTile(
                                                        cancelOffer: () {
                                                          print(offersProvider
                                                              .displayedPending[
                                                                  i]
                                                              .id);
                                                          cancelPendingOffer(
                                                              offersProvider
                                                                  .displayedPending[
                                                                      i]
                                                                  .id);
                                                        },
                                                        pendingOffer: offersProvider
                                                            .displayedPending[i],
                                                        extendOffer: () {
                                                          extendOfferForTwoDays(
                                                              offersProvider
                                                                  .displayedPending[
                                                                      i]
                                                                  .id);
                                                        },
                                                      ));
                                                  // OfferTile.pending(offersProvider.pending[i]);
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return SizedBox(
                                                    height: 15,
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      : NotFoundWidget.offers()),

                              ///APPROVED OFFERS
                              RefreshIndicator(
                                onRefresh: refreshApprovedRequests,
                                child: offersProvider.displayedApproved.length >
                                        0
                                    ? ListView.separated(
                                        padding: EdgeInsets.only(bottom: 25),
                                        shrinkWrap: true,
                                        itemCount: offersProvider
                                            .displayedApproved.length,
                                        itemBuilder: (cnxt, i) => FadeInUp(
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: ApprovedExpiredRequestTile(
                                              approved: true,
                                              offer: offersProvider
                                                  .displayedApproved[i],
                                              // extendOffer: () {
                                              //   extendOfferForTwoDays(
                                              //       offersProvider
                                              //           .displayedPending[i]
                                              //           .id);
                                              // },
                                            )),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          height: 15,
                                        ),
                                      )
                                    : NotFoundWidget.offers(),
                              ),

                              ///EXPIRED OFFERS
                              RefreshIndicator(
                                  onRefresh: refreshExpiredRequests,
                                  child: offersProvider
                                              .displayedExpired.length >
                                          0
                                      ? ListView.separated(
                                          padding: EdgeInsets.only(bottom: 25),
                                          shrinkWrap: true,
                                          itemCount: offersProvider
                                              .displayedExpired.length,
                                          itemBuilder: (cnxt, i) {
                                            print(offersProvider
                                                .displayedExpired[0].id);
                                            return FadeInUp(
                                                duration:
                                                Duration(milliseconds: 200),
                                                child: ApprovedExpiredRequestTile(
                                                  approved: false,
                                                  offer: offersProvider
                                                      .displayedExpired[i],
                                                  extendOffer: () {
                                                    print(offersProvider
                                                        .displayedExpired[i].id);
                                                    extendExpiredOfferForTwoDays(
                                                        offersProvider
                                                            .displayedExpired[i]
                                                            .id);
                                                  },
                                                ));
                                          } ,
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                            height: 15,
                                          ),
                                        )
                                      : NotFoundWidget.offers()),
                            ],
                          ),
                        ),
                )
              ],
            ).setPageHorizontalPadding(context)));
  }

  /// SEARCH FEATURE GO TO > OFFERS PROVIDER
  searchRequests() {
    print(currentPage);
    Provider.of<OffersProvider>(context, listen: false)
        .searchInRequests(_searchTextController.text, currentPage);
  }

  sortRequests() {}

  setFilters() {}

  ///FETCHING DATA
  Future refreshNewRequests() async {
    await Provider.of<OffersProvider>(context, listen: false)
        .loadOfferRequests(forceReload: true);
  }

  Future refreshPendingRequests() async {
    await Provider.of<OffersProvider>(context, listen: false)
        .loadPendingOffersNetworkLayer();
  }

  Future refreshApprovedRequests() async {
    await Provider.of<OffersProvider>(context, listen: false)
        .loadApprovedOffersNetworkLayer();
  }

  Future refreshExpiredRequests() async {
    await Provider.of<OffersProvider>(context, listen: false)
        .loadExpiredOffersNetworkLayer();
  }

  /// USER INTERACTIONS

  cancelPendingOffer(int id) {
    EasyLoading.show();
    Provider.of<OffersProvider>(context, listen: false)
        .cancelPendingOffer(id)
        .then((value) {
      EasyLoading.dismiss();
      if (value) {
        refreshPendingRequests();
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return SuccessMessage(
                message: 'Offer $id Canceled Successfully',
              );
            });
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  extendOfferForTwoDays(int id) {
    EasyLoading.show();
    Provider.of<OffersProvider>(context, listen: false)
        .extendOffer(id)
        .then((value) {
      EasyLoading.dismiss();
      if (value) {
        refreshPendingRequests();
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return SuccessMessage(
                message: 'Offer $id Extended Successfully',
              );
            });
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  extendExpiredOfferForTwoDays(int id) {
    EasyLoading.show();
    Provider.of<OffersProvider>(context, listen: false)
        .extendOffer(id)
        .then((value) {
      EasyLoading.dismiss();
      if (value) {
        refreshExpiredRequests();
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return SuccessMessage(
                message: 'Expired offer $id Renewed Successfully',
              );
            });
      } else {
        EasyLoading.dismiss();
      }
    });
  }

  extendAllOffers() {
    EasyLoading.show();
    Provider.of<OffersProvider>(context, listen: false)
        .extendAllOffers()
        .then((value) {
      EasyLoading.dismiss();
      if (value) {
        refreshPendingRequests();
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });
              return SuccessMessage(
                message: 'All Offers Has been Extended',
              );
            });
      } else {
        EasyLoading.dismiss();
      }
    });
  }
}
