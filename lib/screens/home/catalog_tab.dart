import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/models/brand.dart';
import 'package:revmo/models/car.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/catalog/catalog_grid.dart';
import 'package:revmo/shared/widgets/catalog/catalog_tile.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:revmo/shared/widgets/home/search_bar.dart';
import 'package:revmo/shared/widgets/main_button.dart';
import 'package:revmo/shared/widgets/revmo_icon_only_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CatalogTab extends StatefulWidget {
  static const String screenName = "catalogTab";

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  final double _barHeight = 40;
  final double _iconsPadding = 10;
  final double _titleTopMargin = 14;
  final double _titleBotMargin = 5;
  final double _restTitleBotMargin = 10;
  final double _blueHighlightWidth = 10;
  final double _blueHighlightHeight = 3;

  final TextEditingController _textEditingController = new TextEditingController();
  final PageController _pagesController = new PageController();

  List<Car>? myCatalog;
  List<Brand>? brand;

  int pageIndex = 0;
  @override
  void initState() {
    myCatalog = []; //Car.testdata;
    pageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(myCatalog?.length);
    return Scaffold(
      appBar: RevmoAppBar(),
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
            Container(
              width: double.infinity,
              child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.carCatalog, 3),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: _barHeight,
              child: Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      height: _barHeight,
                      searchCallback: searchItem,
                      textEditingController: _textEditingController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 3, right: 1),
                    child: RevmoIconButton(
                      callback: sortItems,
                      width: _barHeight,
                      color: RevmoColors.petrolBlue,
                      iconWidget: SvgPicture.asset(Paths.sortSVG),
                      iconPadding: _iconsPadding,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 1),
                      child: RevmoIconButton(
                        callback: filterItems,
                        width: _barHeight,
                        color: RevmoColors.originalBlue,
                        iconWidget: SvgPicture.asset(Paths.filtersSVG),
                        iconPadding: _iconsPadding,
                      )),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: GestureDetector(
                              onTap: goToMyCatalog,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: _titleTopMargin, bottom: _titleBotMargin),
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      child: RevmoTheme.getSemiBold(
                                          AppLocalizations.of(context)!.myCatalog +
                                              " (" +
                                              (myCatalog == null ? "0" : myCatalog!.length.toString()) +
                                              ")",
                                          2,
                                          color: (pageIndex == 0) ? Colors.white : RevmoColors.darkGrey),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: _restTitleBotMargin),
                                    width: _blueHighlightWidth,
                                    height: _blueHighlightHeight,
                                    color: (pageIndex == 0) ? RevmoColors.originalBlue : Colors.transparent,
                                  )
                                ],
                              ))),
                      Flexible(
                          child: GestureDetector(
                              onTap: goToCarPool,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: _titleTopMargin, bottom: _titleBotMargin),
                                    alignment: Alignment.centerRight,
                                    child: FittedBox(
                                      child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.carCatalog, 2,
                                          color: (pageIndex == 1) ? Colors.white : RevmoColors.darkGrey),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: _restTitleBotMargin),
                                    width: _blueHighlightWidth,
                                    height: _blueHighlightHeight,
                                    color: (pageIndex == 1) ? RevmoColors.originalBlue : Colors.transparent,
                                  )
                                ],
                              ))),
                    ],
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
                          Container(
                            child: (myCatalog == null)
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: RevmoColors.darkGrey,
                                    ),
                                  )
                                : (myCatalog?.length == 0)
                                    ? Center(
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        SvgPicture.asset(
                                          Paths.emptyCatalogSVG,
                                          color: RevmoColors.darkerBlue,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FittedBox(
                                          child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.noCars, 2,
                                              color: RevmoColors.originalBlue),
                                        ),
                                        FittedBox(
                                          child: RevmoTheme.getBody(AppLocalizations.of(context)!.noCarsCaption, 1),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        MainButton(
                                            width: double.infinity,
                                            text: AppLocalizations.of(context)!.addCars,
                                            callBack: goToCarPool)
                                      ]))
                                    : ListView.builder(
                                        itemCount: myCatalog!.length,
                                        itemBuilder: (cntx, index) {
                                          return CatalogTile(myCatalog![index]);
                                        }),
                          ),

                          //Cars Catalog
                          CatalogGrid()
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
    _pagesController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  goToCarPool() {
    _pagesController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  sortItems() {}

  filterItems() {}

  searchItem() {
    print(_textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
