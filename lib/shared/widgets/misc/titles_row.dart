import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class TitlesRow extends StatelessWidget {
  final Map<String, Function()?> titlesMap;
  final List<String>? subtitles;
  final int currentSelected;
  final double _blueHighlightWidth = 10;
  final double _blueHighlightHeight = 3;
  const TitlesRow(this.titlesMap, this.currentSelected, {this.subtitles})
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
         
                    margin:
                        EdgeInsetsDirectional.only(top: _titleTopMargin, bottom: _titleBotMargin, end: i != titlesMap.length - 1 ? 10 : 0),
                    alignment: titlesMap.length > 1
                        ? AlignmentDirectional.lerp(AlignmentDirectional.centerStart, AlignmentDirectional.centerEnd, i / (titlesMap.length - 1))
                        : Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: entry.value,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          FittedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                RevmoTheme.getSemiBold(entry.key, 1,
                                    color: (currentSelected == i) ? Colors.white : RevmoColors.darkGrey),
                                if (subtitles != null && subtitles!.length>i)
                                  RevmoTheme.getCaption(subtitles![i], 1,
                                      color: (currentSelected == i) ? Colors.white : RevmoColors.darkGrey),
                              ],
                            ),
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

        
        );
  }
}
