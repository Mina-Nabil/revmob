import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/offers_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/default_header.dart';
import 'package:revmo/shared/widgets/misc/no_cars_found.dart';
import 'package:revmo/shared/widgets/misc/not_found_widget.dart';
import 'package:revmo/shared/widgets/misc/titles_row.dart';
import 'package:revmo/shared/widgets/offers/offer_tile.dart';

class RequestsTab extends StatefulWidget {
  static const String screenName = "requestsTab";
  const RequestsTab();

  @override
  _RequestsTabState createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  int currentPage = 0;
  bool isLoading = true;
  final TextEditingController _searchTextController = new TextEditingController();
  PageController _pageController = new PageController();
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<OffersProvider>(context, listen: false).loadOfferRequests();
      await Provider.of<OffersProvider>(context, listen: false).loadPendingOffers();
      await Provider.of<OffersProvider>(context, listen: false).loadApprovedOffers();
      await Provider.of<OffersProvider>(context, listen: false).loadExpiredOffers();
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: Container(
            padding: HomeScreen.HORIZONTAL_PADDING,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //tab title
                ...[
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.requests, 3),
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
                    hideFilterbutton: false,
                    hideSortbutton: false,
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
                      " (" + Provider.of<OffersProvider>(context).newRequests.length.toString() + ")",
                      " (" + Provider.of<OffersProvider>(context).pending.length.toString() + ")",
                      " (" + Provider.of<OffersProvider>(context).approved.length.toString() + ")",
                      " (" + Provider.of<OffersProvider>(context).expired.length.toString() + ")",
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
                                child: offersProvider.newRequests.length > 0
                                    ? ListView.builder(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        shrinkWrap: true,
                                        itemCount: offersProvider.newRequests.length,
                                        itemBuilder: (cnxt, i) => OfferTile.request(offersProvider.newRequests[i]))
                                    : NotFoundWidget.offers(),
                              ),
                              RefreshIndicator(
                                  onRefresh: refreshPendingRequests,
                                  child: offersProvider.pending.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          shrinkWrap: true,
                                          itemCount: offersProvider.pending.length,
                                          itemBuilder: (cnxt, i) => OfferTile.pending(offersProvider.pending[i]),
                                        )
                                      : NotFoundWidget.offers()),
                              RefreshIndicator(
                                onRefresh: refreshApprovedRequests,
                                child: offersProvider.approved.length > 0
                                    ? ListView.builder(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        shrinkWrap: true,
                                        itemCount: offersProvider.approved.length,
                                        itemBuilder: (cnxt, i) => OfferTile.approved(offersProvider.approved[i]))
                                    : NotFoundWidget.offers(),
                              ),
                              RefreshIndicator(
                                  onRefresh: refreshExpiredRequests,
                                  child: offersProvider.approved.length > 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          shrinkWrap: true,
                                          itemCount: offersProvider.expired.length,
                                          itemBuilder: (cnxt, i) => OfferTile.expired(offersProvider.expired[i]))
                                      : NotFoundWidget.offers()),
                            ],
                          ),
                        ),
                )
              ],
            )));
  }

  searchRequests() {}

  sortRequests() {}

  setFilters() {}

  Future refreshNewRequests() async {
    await Provider.of<OffersProvider>(context, listen: false).loadOfferRequests(forceReload: true);
  }

  Future refreshPendingRequests() async {
    await Provider.of<OffersProvider>(context, listen: false).loadPendingOffers(forceReload: true);
  }

  Future refreshApprovedRequests() async {
    await Provider.of<OffersProvider>(context, listen: false).loadApprovedOffers(forceReload: true);
  }

  Future refreshExpiredRequests() async {
    await Provider.of<OffersProvider>(context, listen: false).loadExpiredOffers(forceReload: true);
  }
}
