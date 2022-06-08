import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/customers_provider.dart';
import 'package:revmo/shared/colors.dart';

import '../../environment/paths.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/Customers/LoadingShimmers/customer_tile_loading_widget.dart';
import '../../shared/widgets/Customers/customer_tile_list.dart';
import '../../shared/widgets/home/search_bar.dart';
import '../../shared/widgets/misc/not_found_widget.dart';
import '../../shared/widgets/misc/revmo_icon_only_button.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';

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
    // Provider.of<CustomersProvider>(context, listen: false).setFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomersProvider>(context);

    return Scaffold(
      backgroundColor: RevmoColors.darkBlue,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Text(
            "Customers",
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: RevmoTheme.SEARCH_BAR_HEIGHT,
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  height: RevmoTheme.SEARCH_BAR_HEIGHT,
                  searchCallback: () {
                    Provider.of<CustomersProvider>(context, listen: false)
                        .searchInTeam(customerProvider.search.text);
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
                        barrierColor: RevmoColors.backgroundDim,
                        backgroundColor: Colors.transparent,
                        elevation: 12.0,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(top: 40),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text('Search By ',style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 20),),
                                ListTile(
                                  onTap: (){
                               customerProvider.setSearchType('buyerName');
                               Navigator.pop(context);

                                  },
                                  leading:
                                customerProvider.searchTypeCheck == 0 ?
                                Icon(Icons.check, color: RevmoColors.originalBlue,) : SizedBox(),
                                title: Text('Buyer Name',style: TextStyle(color: RevmoColors.darkBlue,  fontSize: 16),),

                                ),

                                ListTile(
                                  onTap: (){
                                    customerProvider.setSearchType('sellerName');
                                    Navigator.pop(context);

                                  },
                                  leading:
                                  customerProvider.searchTypeCheck == 1 ?
                                  Icon(Icons.check, color: RevmoColors.originalBlue,) : SizedBox(),
                                  title: Text('Seller Name',style: TextStyle(color: RevmoColors.darkBlue,  fontSize: 16),),

                                ),
                              ],
                            ),),);
                  },
                  width: RevmoTheme.SEARCH_BAR_HEIGHT,
                  color: RevmoColors.petrol,
                  iconWidget:
                      SvgPicture.asset(Paths.sortSVG, color: Colors.white),
                  iconPadding: 10,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 5),
                  child: RevmoIconButton(
                    callback: null,
                    width: RevmoTheme.SEARCH_BAR_HEIGHT,
                    color: RevmoColors.originalBlue,
                    iconWidget:
                        SvgPicture.asset(Paths.filtersSVG, color: Colors.white),
                    iconPadding: 10,
                  )),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: fetchCustomers,
            child: FutureBuilder(
              future: customerProvider.customersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Oops.. Something went wrong !',
                      style: TextStyle(color: Colors.grey),
                    ));
                  } else if (customerProvider.displayedCustomersList.isEmpty) {
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
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                    );

                    // Center(child: CircularProgressIndicator(),);
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: customerProvider.displayedCustomersList.length,
                      itemBuilder: (context, index) => FadeInUp(
                        duration: Duration(milliseconds: 300),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomersDetails(
                                          customer: customerProvider
                                              .displayedCustomersList[index],
                                        )));
                          },
                          child: CustomersListTile(
                            customerSoldOffer:
                                customerProvider.displayedCustomersList[index],
                          ),
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
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
        .fetchCustomers();
  }
}
