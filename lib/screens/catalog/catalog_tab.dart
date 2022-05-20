import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/models/cars/car.dart';
import 'package:revmo/models/cars/brand.dart';
import 'package:revmo/models/cars/model.dart';
import 'package:revmo/models/cars/model_color.dart';
import 'package:revmo/providers/catalog_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/brands_grid_page.dart';
import 'package:revmo/shared/widgets/catalog/my_catalog_page.dart';
import 'package:revmo/shared/widgets/misc/default_header.dart';
import 'package:revmo/shared/widgets/misc/no_cars_found.dart';
import 'package:revmo/shared/widgets/misc/revmo_filter_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/titles_row.dart';

class CatalogTab extends StatefulWidget {
  static const String screenName = "catalogTab";

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  final TextEditingController _textEditingController = new TextEditingController();
  final PageController _pagesController = new PageController();

  //page filters
  ValueNotifier<HashSet<Brand>> _brandFilters = new ValueNotifier(HashSet<Brand>());
  ValueNotifier<HashSet<ModelColor>> _colorFilters = new ValueNotifier(HashSet<ModelColor>());
  ValueNotifier<HashSet<CarModel>> _modelFilters = new ValueNotifier(HashSet<CarModel>());
  ValueNotifier<HashSet<Car>> _catgFilters = new ValueNotifier(HashSet<Car>());
  ValueNotifier<double> minPrice = new ValueNotifier(0);
  ValueNotifier<double> maxPrice = new ValueNotifier(0);

  ValueNotifier<String?> brandSearch = new ValueNotifier<String?>(null);

  int pageIndex = 0;
  bool isLoadingMyCatalog = true;
  bool hideCatalog = false;
  DateTime latestRefresh = DateTime.now();

  Future refreshMyCatalog() async {
    setState(() {
      hideCatalog = true;
      isLoadingMyCatalog = true;
    });
    bool forceRefresh =
        (DateTime.now().difference(latestRefresh)).inSeconds > 5; //if latest refresh occured more than 5 seconds ago
    await Provider.of<CatalogProvider>(context, listen: false).loadCatalog(forceLoad: forceRefresh);
    refreshFilters();
    if (forceRefresh) latestRefresh = DateTime.now();
    setState(() {
      hideCatalog = false;
      isLoadingMyCatalog = false;
    });
  }

  refreshFilters() {
    _brandFilters.value.clear();
    _modelFilters.value.clear();
    _colorFilters.value.clear();
    _catgFilters.value.clear();
    minPrice.value = Provider.of<CatalogProvider>(context, listen: false).catalog.minCarPrice;
    maxPrice.value = Provider.of<CatalogProvider>(context, listen: false).catalog.maxCarPrice;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<CatalogProvider>(context, listen: false).loadCatalog();
      setState(() {
        minPrice.value = Provider.of<CatalogProvider>(context, listen: false).catalog.minCarPrice;
        maxPrice.value = Provider.of<CatalogProvider>(context, listen: false).catalog.maxCarPrice;
        isLoadingMyCatalog = false;
      });
    });
    pageIndex = 0;
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
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.carCatalog, 3),
            ),
            SizedBox(
              height: 15,
            ),
            //search & filters
            RevmoDefaultHeader(
              searchCallback: !isLoadingMyCatalog ? ((pageIndex == 0) ? searchCatalog : searchBrands) : null,
              searchTextController: _textEditingController,
              filterCallback: (pageIndex == 0 && !isLoadingMyCatalog) ? filterCatalog : null,
              sortCallback: (pageIndex == 0 && !isLoadingMyCatalog) ? sortCatalog : null,
            ),

            //catalog tabs
            Expanded(
              child: Column(
                children: [
                  TitlesRow(
                    {
                      AppLocalizations.of(context)!.myCatalog: goToMyCatalog,
                      AppLocalizations.of(context)!.addCars: goToCarPool,
                    },
                    pageIndex,
                    subtitles: [" (" + Provider.of<CatalogProvider>(context).filteredCatalog.length.toString() + ")"],
                  ),
                  Expanded(
                    child: PageView(
                        controller: _pagesController,
                        onPageChanged: (index) {
                          setState(() {
                            pageIndex = index;
                          });
                        },
                        children: [
                          //My Catalog
                          RefreshIndicator(
                            onRefresh: refreshMyCatalog,
                            child: Container(
                              child: (isLoadingMyCatalog)
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: RevmoColors.darkGrey,
                                      ),
                                    )
                                  : (hideCatalog)
                                      ? Container()
                                      : (Provider.of<CatalogProvider>(context).filteredCatalog.length == 0)
                                          ? LayoutBuilder(
                                              builder: (context, constraints) => ListView(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: constraints.maxHeight,
                                                    child: NoCarsFound(
                                                      Provider.of<CatalogProvider>(context).catalog.isEmpty,
                                                      addButtonFunc: goToCarPool,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : MyCatalogPage(),
                            ),
                          ),
                          //Cars Catalog
                          BrandsGrid(brandSearch)
                        ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  goToMyCatalog() {
    _pagesController.animateToPage(0, duration: RevmoTheme.PAGES_DURATION, curve: RevmoTheme.PAGES_CURVE);
  }

  goToCarPool() {
    _pagesController.animateToPage(1, duration: RevmoTheme.PAGES_DURATION, curve: RevmoTheme.PAGES_CURVE);
  }

  sortCatalog() {}

  filterCatalog() async {
    if (minPrice.value > Provider.of<CatalogProvider>(context, listen: false).catalog.maxCarPrice ||
        minPrice.value < Provider.of<CatalogProvider>(context, listen: false).catalog.minCarPrice ||
        maxPrice.value > Provider.of<CatalogProvider>(context, listen: false).catalog.maxCarPrice ||
        maxPrice.value < Provider.of<CatalogProvider>(context, listen: false).catalog.minCarPrice) refreshFilters();
    bool? res = await showModalBottomSheet<bool>(
        barrierColor: RevmoColors.backgroundDim,
        backgroundColor: Colors.transparent,
        elevation: 12.0,
        isScrollControlled: true,
        context: context,
        builder: (context) => RevmoFiltersSheet(Provider.of<CatalogProvider>(context).catalog, _brandFilters, _modelFilters,
            _catgFilters, _colorFilters, minPrice, maxPrice));

    searchCatalog();
  }

  searchCatalog() {
    Provider.of<CatalogProvider>(context, listen: false).filterCatalog(
        search: _textEditingController.text.trim(),
        brands: _brandFilters.value,
        catgs: _catgFilters.value,
        colors: _colorFilters.value,
        models: _modelFilters.value,
        minPrice: minPrice.value,
        maxPrice: maxPrice.value);
  }

  searchBrands() {
    brandSearch.value = _textEditingController.text.trim();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
