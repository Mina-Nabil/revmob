import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class TitlesRow extends StatelessWidget {
  final Map<String, Function()?> titlesMap;
  final int currentSelected;
  final double _blueHighlightWidth = 10;
  final double _blueHighlightHeight = 3;
  const TitlesRow(this.titlesMap, this.currentSelected)
      : assert(currentSelected < titlesMap.length, "current is larger than map size..");

  final double _titleTopMargin = 14;
  final double _titleBotMargin = 5;
  final double _restTitleBotMargin = 10;

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: titlesMap.entries
            .map<Widget>((entry) => Flexible(
                fit: FlexFit.tight,
                child: Container(
                    margin: EdgeInsets.only(top: _titleTopMargin, bottom: _titleBotMargin),
                    alignment: titlesMap.length > 1
                        ? Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, i / (titlesMap.length - 1))
                        : Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: entry.value,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          FittedBox(
                            child: RevmoTheme.getSemiBold(entry.key, 2,
                                color: (currentSelected == i) ? Colors.white : RevmoColors.darkGrey),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: _restTitleBotMargin),
                            width: _blueHighlightWidth,
                            height: _blueHighlightHeight,
                            color: (currentSelected == i++) ? RevmoColors.originalBlue : Colors.transparent,
                          )
                        ])))))
            .toList()

        //  [

        //   Flexible(
        //       child: GestureDetector(
        //           onTap: goToMyCatalog,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Container(
        //                 margin: EdgeInsets.only(top: _titleTopMargin, bottom: _titleBotMargin),
        //                 alignment: Alignment.centerLeft,
        //                 child: FittedBox(
        //                   child: RevmoTheme.getSemiBold(
        //                       AppLocalizations.of(context)!.myCatalog +
        //                           " (" +
        //                           Provider.of<CatalogProvider>(context).filteredCatalog.length.toString() +
        //                           ")",
        //                       2,
        //                       color: (pageIndex == 0) ? Colors.white : RevmoColors.darkGrey),
        //                 ),
        //               ),
        //               Container(
        //                 margin: EdgeInsets.only(bottom: _restTitleBotMargin),
        //                 width: _blueHighlightWidth,
        //                 height: _blueHighlightHeight,
        //                 color: (pageIndex == 0) ? RevmoColors.originalBlue : Colors.transparent,
        //               )
        //             ],
        //           ))),
        //   Flexible(
        //       child: GestureDetector(
        //           onTap: goToCarPool,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: [
        //               Container(
        //                 margin: EdgeInsets.only(top: _titleTopMargin, bottom: _titleBotMargin),
        //                 alignment: Alignment.centerRight,
        //                 child: FittedBox(
        //                   child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.carCatalog, 2,
        //                       color: (pageIndex == 1) ? Colors.white : RevmoColors.darkGrey),
        //                 ),
        //               ),
        //               Container(
        //                 margin: EdgeInsets.only(bottom: _restTitleBotMargin),
        //                 width: _blueHighlightWidth,
        //                 height: _blueHighlightHeight,
        //                 color: (pageIndex == 1) ? RevmoColors.originalBlue : Colors.transparent,
        //               )
        //             ],
        //           ))),
        // ],
        );
  }
}
