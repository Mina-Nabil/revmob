import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/customers_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../environment/paths.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/Customers/LoadingShimmers/customer_tile_loading_widget.dart';
import '../../shared/widgets/Customers/customer_tile_list.dart';
import '../../shared/widgets/home/search_bar.dart';
import '../../shared/widgets/misc/not_found_widget.dart';
import '../../shared/widgets/misc/revmo_icon_only_button.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';

import '../../shared/widgets/misc/secondary_button.dart';
import 'customersDetails/customers_details.dart';

class CustomersTab extends StatefulWidget {
  static const String screenName = "customerTab";

  @override
  _CustomersTabState createState() => _CustomersTabState();
}

class _CustomersTabState extends State<CustomersTab> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 800), () {
      Provider.of<CustomersProvider>(context, listen: false).setFuture();
    });
    super.initState();
  }

  int searchTypeCheck = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomersProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: RevmoColors.darkBlue,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Text(
            AppLocalizations.of(context)!.customers,
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        customerProvider.isConnected == false
            ? SizedBox.shrink()
            : Container(
                height: RevmoTheme.SEARCH_BAR_HEIGHT,
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchBar(
                        height: RevmoTheme.SEARCH_BAR_HEIGHT,
                        searchCallback: () {
                          Provider.of<CustomersProvider>(context, listen: false)
                              .searchInTeam(
                                  customerProvider.search.text.toLowerCase());
                          print(customerProvider.search.text);
                        },
                        textEditingController: customerProvider.search,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 1),
                      child: RevmoIconButton(
                        callback: () {
                          showModalBottomSheet<bool>(
                              // useRootNavigator:true,
                              barrierColor: RevmoColors.backgroundDim,
                              backgroundColor: Colors.transparent,
                              elevation: 10.0,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => BottomSheetWidget());
                        },
                        width: RevmoTheme.SEARCH_BAR_HEIGHT,
                        color: RevmoColors.petrol,
                        iconWidget: SvgPicture.asset(Paths.sortSVG,
                            color: Colors.white),
                        iconPadding: 10,
                      ),
                    ),
                    // IgnorePointer(
                    //   ignoring: true,
                    //   child: Container(
                    //       margin: EdgeInsets.only(left: 5),
                    //       child: RevmoIconButton(
                    //         callback: () {
                    //           // showModalBottomSheet<bool>(
                    //           //     barrierColor: RevmoColors.backgroundDim,
                    //           //     backgroundColor: Colors.transparent,
                    //           //     elevation: 10.0,
                    //           //     isScrollControlled: true,
                    //           //     context: context,
                    //           //     builder: (context) => FilterBottomSheet());
                    //         },
                    //         width: RevmoTheme.SEARCH_BAR_HEIGHT,
                    //         color: RevmoColors.originalBlue.withOpacity(0.5),
                    //         iconWidget: SvgPicture.asset(Paths.filtersSVG,
                    //             color: Colors.white.withOpacity(0.5)),
                    //         iconPadding: 10,
                    //       )),
                    // ),
                  ],
                )),
        customerProvider.isConnected == false
            ? Expanded(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie.asset('assets/images/disconnect.json',
                    //     repeat: true,
                    //     height: 200,
                    //     frameRate: FrameRate.composition),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Oops! Can't move forward",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
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
                      onPressed: () {
                        customerProvider.fetchCustomersNetworkLayer();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.again,
                      ),
                    )
                  ],
                )),
              )
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchCustomers,
                  child: FutureBuilder(
                    future: customerProvider.customersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError == true) {
                          return Center(
                              child: Text(
                            'Oops.. Something went wrong !',
                            style: TextStyle(color: Colors.grey),
                          ));
                        } else if (customerProvider
                            .displayedCustomersList.isEmpty) {
                          return FadeInUp(
                            child: Center(
                              child: NotFoundWidget.customers(),
                              // fetchCustomers
                            ),
                          );
                        } else if (customerProvider.isLoading == true) {
                          print(customerProvider.isLoading);
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) => FadeInUp(
                                duration: Duration(milliseconds: 300),
                                child: CustomTileLoadingWidget()),
                            // child: Text('hell')),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 20,
                              );
                            },
                          );

                          // Center(child: CircularProgressIndicator(),);
                        } else {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount:
                                customerProvider.displayedCustomersList.length,
                            itemBuilder: (context, index) => FadeInUp(
                              duration: Duration(milliseconds: 300),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          // builder: (context) =>Profile()
                                          builder: (context) =>
                                              CustomersDetails(
                                                customer: customerProvider
                                                        .displayedCustomersList[
                                                    index],
                                              )));
                                },
                                child: CustomersListTile(
                                  customerSoldOffer: customerProvider
                                      .displayedCustomersList[index],
                                ),
                              ),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 20,
                              );
                            },
                          );
                        }
                      } else {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) => FadeInUp(
                              duration: Duration(milliseconds: 300),
                              child: CustomTileLoadingWidget()),
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 20,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              )
      ]).setPageHorizontalPadding(context),
    );
  }

  Future fetchCustomers() async {
    await Provider.of<CustomersProvider>(context, listen: false)
        .fetchCustomersNetworkLayer();
  }
}

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomersProvider>(context);
    double _values = 100.0;
    double maxPriceWidget = customerProvider.maxCarPrice;
    double minPriceWidget = customerProvider.minCarPrice;

// print(customerProvider.displayedCustomersList[1].car!.model.name);
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.filters,
              style: TextStyle(
                  color: RevmoColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.brands,
              style: TextStyle(
                  color: RevmoColors.originalBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            MultiSelectContainer(
                maxSelectableCount: 1,
                controller: customerProvider.multiSelectController,
                wrapSettings: const WrapSettings(runSpacing: 10),
                items: List.generate(
                    customerProvider.retrievedBrandsList
                        .toSet()
                        .toList()
                        .length, (index) {
                  final data = customerProvider.retrievedBrandsList
                      .toSet()
                      .toList()[index];
                  return MultiSelectCard(
                      value: data,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 20,
                            child: Image.network(data.logoURL),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            data.name,
                            style: TextStyle(
                                color: RevmoColors.darkBlue,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      splashColor: RevmoColors.originalBlue,
                      highlightColor: RevmoColors.originalBlue,
                      contentPadding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decorations: MultiSelectItemDecorations(
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.2),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          selectedDecoration: BoxDecoration(
                              color: Color(0xff003157).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          disabledDecoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.grey[500]!),
                              borderRadius: BorderRadius.circular(5))),
                      textStyles: MultiSelectItemTextStyles(
                        textStyle: TextStyle(
                            color: RevmoColors.darkBlue,
                            fontWeight: FontWeight.bold),
                        selectedTextStyle: const TextStyle(
                            color: RevmoColors.darkBlue,
                            fontWeight: FontWeight.bold),
                      ));
                }),
                onMaximumSelected: (allSelectedItems, selectedItem) {
                  print('the limit has been reached');
                  // CustomSnackBar.showInSnackBar('The limit has been reached', context);
                },
                onChange: (allSelectedItems, selectedItem) {
                  customerProvider.setBrandFilterName(selectedItem.toString());
                  customerProvider.setBrandFilter();
                }),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.price,
              style: TextStyle(
                  color: RevmoColors.originalBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                    child: RevmoTheme.getBody(
                        (customerProvider.minCarPrice / 1000)
                                .round()
                                .toString() +
                            "k",
                        1,
                        color: RevmoColors.darkerBlue)),
                Flexible(
                  fit: FlexFit.tight,
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: RevmoColors.originalBlue,
                      trackHeight: 0.25,
                      inactiveTrackColor: RevmoColors.grey,
                      valueIndicatorColor: RevmoColors.originalBlue,
                    ),
                    child: RangeSlider(
                      min: minPriceWidget,
                      max: maxPriceWidget<0?0:maxPriceWidget,
                      values: new RangeValues(minPriceWidget, maxPriceWidget),
                      onChanged: (values) {
                        setState(() {
                          minPriceWidget =
                              (values.start / 1000).roundToDouble() * 1000;
                          maxPriceWidget =
                              (values.end / 1000).roundToDouble() * 1000;
                        });
                      },
                    ),
                  ),
                ),
                FittedBox(
                    child: RevmoTheme.getBody(
                        (customerProvider.maxCarPrice).round().toString(), 1,
                        color: RevmoColors.darkerBlue)),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SecondaryButton(
              text: AppLocalizations.of(context)!.reset,
              callBack: () {
                customerProvider.resetFilters();
              },
              textColor: RevmoColors.originalBlue,
            ),
            SecondaryButton(
              text: AppLocalizations.of(context)!.cancel,
              callBack: () {
                Navigator.pop(context);
              },
              textColor: RevmoColors.originalBlue,
            ),
          ],
        )));
  }
}

//sorting bottom sheet
class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  double heightSheet = 0.40;

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomersProvider>(context);

    return Container(
        height: MediaQuery.of(context).size.height * heightSheet,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 40),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              AppLocalizations.of(context)!.sortBy,
              style: TextStyle(
                  color: RevmoColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            ListTile(
              minLeadingWidth: 0,
              onTap: () {
                customerProvider.sortByCreationDate();
                customerProvider.setSortByIndex(0);
                print(customerProvider.sortTypeCheck);
              },
              leading: customerProvider.sortTypeCheck == 0
                  ? Icon(
                      Icons.check,
                      size: 22,
                      color: RevmoColors.originalBlue,
                    )
                  : SizedBox(
                      width: 22,
                    ),
              title: Text(
                AppLocalizations.of(context)!.creationDate,
                style: TextStyle(color: RevmoColors.darkBlue, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            ListTile(
              minLeadingWidth: 0,
              onTap: () {
                customerProvider.setSortByIndex(2);
                customerProvider.sortByExpiryDate();
              },
              leading: customerProvider.sortTypeCheck == 2
                  ? Icon(
                      Icons.check,
                      size: 22,
                      color: RevmoColors.originalBlue,
                    )
                  : SizedBox(
                      width: 22,
                    ),
              title: Text(
                AppLocalizations.of(context)!.expiryDate,
                style: TextStyle(color: RevmoColors.darkBlue, fontSize: 16),
              ),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            ExpansionTile(
              childrenPadding: EdgeInsets.only(left: 15, right: 15),
              children: [
                ListTile(
                  minLeadingWidth: 0,
                  onTap: () {
                    customerProvider.sortByPrice(true);
                    customerProvider.setSortPriceByIndex(0);
                  },
                  leading: customerProvider.sortPriceIndex == 0
                      ? Icon(
                          Icons.check,
                          size: 18,
                          color: RevmoColors.originalBlue,
                        )
                      : SizedBox(
                          width: 18,
                        ),
                  title: Text(
                    AppLocalizations.of(context)!.priceHighToLow,
                    style: TextStyle(color: RevmoColors.darkBlue, fontSize: 14),
                  ),
                ),
                ListTile(
                  minLeadingWidth: 0,
                  onTap: () {
                    customerProvider.sortByPrice(false);
                    customerProvider.setSortPriceByIndex(1);
                  },
                  leading: customerProvider.sortPriceIndex == 1
                      ? Icon(
                          Icons.check,
                          size: 18,
                          color: RevmoColors.originalBlue,
                        )
                      : SizedBox(
                          width: 18,
                        ),
                  title: Text(
                    AppLocalizations.of(context)!.priceLowToHigh,
                    style: TextStyle(color: RevmoColors.darkBlue, fontSize: 14),
                  ),
                ),
              ],
              leading: SizedBox.shrink(),
              tilePadding: EdgeInsets.zero,
              title: Text(
                AppLocalizations.of(context)!.price,
                style: TextStyle(color: RevmoColors.darkBlue, fontSize: 16),
              ),
              initiallyExpanded: false,
              collapsedIconColor: RevmoColors.originalBlue,
            ),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            SizedBox(
              height: 20,
            ),
            SecondaryButton(
              text: AppLocalizations.of(context)!.reset,
              callBack: () {
                customerProvider.resetSortBy();
              },
              textColor: RevmoColors.originalBlue,
            ),
            SecondaryButton(
              text: AppLocalizations.of(context)!.cancel,
              callBack: () {
                Navigator.pop(context);
              },
              textColor: RevmoColors.originalBlue,
            ),
          ]),
        ));
  }
}
