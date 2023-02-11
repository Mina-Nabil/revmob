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
          .loadPendingOffers();
      await Provider.of<OffersProvider>(context, listen: false)
          .loadApprovedOffers();
      await Provider.of<OffersProvider>(context, listen: false)
          .loadExpiredOffers();
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
            // padding: HomeScreen.HORIZONTAL_PADDING,
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
                              RefreshIndicator(
                                onRefresh: refreshNewRequests,
                                child: offersProvider.displayedNew.length > 0
                                    ? ListView.builder(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
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
                                                          cancelPendingOffer(offersProvider
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
                              RefreshIndicator(
                                onRefresh: refreshApprovedRequests,
                                child: offersProvider.approved.length > 0
                                    ? ListView.builder(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        shrinkWrap: true,
                                        itemCount:
                                            offersProvider.approved.length,
                                        itemBuilder: (cnxt, i) =>
                                            OfferTile.approved(
                                                offersProvider.approved[i]))
                                    : NotFoundWidget.offers(),
                              ),
                              RefreshIndicator(
                                  onRefresh: refreshExpiredRequests,
                                  child: offersProvider.expired.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          shrinkWrap: true,
                                          itemCount:
                                              offersProvider.expired.length,
                                          itemBuilder: (cnxt, i) =>
                                              OfferTile.expired(
                                                  offersProvider.expired[i]))
                                      : NotFoundWidget.offers()),
                            ],
                          ),
                        ),
                )
              ],
            ).setPageHorizontalPadding(context)));
  }

  searchRequests() {
    print(currentPage);
    Provider.of<OffersProvider>(context, listen: false)
        .searchInRequests(_searchTextController.text, currentPage);
  }

  sortRequests() {}

  setFilters() {}

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
        .loadApprovedOffers(forceReload: true);
  }

  Future refreshExpiredRequests() async {
    await Provider.of<OffersProvider>(context, listen: false)
        .loadExpiredOffers(forceReload: true);
  }

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
