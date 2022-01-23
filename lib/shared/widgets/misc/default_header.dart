import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/home/search_bar.dart';
import 'package:revmo/shared/widgets/misc/revmo_icon_only_button.dart';

class RevmoDefaultHeader extends StatelessWidget {
  final double _headerHeight = RevmoTheme.SEARCH_BAR_HEIGHT;
  final double _iconsPadding = 10;

  final Function()? searchCallback;
  final TextEditingController searchTextController;
  final bool hideSortbutton;
  final Function()? sortCallback;
  final bool hideFilterbutton;
  final Function()? filterCallback;
  final String? searchHint;

  const RevmoDefaultHeader(
      {required this.searchCallback,
      required this.searchTextController,
      this.hideSortbutton = false,
      this.sortCallback,
      this.searchHint,
      this.hideFilterbutton = false,
      this.filterCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _headerHeight,
      child: Row(
        children: [
          Expanded(
            child: SearchBar(
              height: _headerHeight,
              searchCallback: searchCallback,
              textEditingController: searchTextController,
              hintText: searchHint,
            ),
          ),
          if (!hideSortbutton)
            Container(
              margin: EdgeInsets.only(left: 3, right: 1),
              child: RevmoIconButton(
                callback: sortCallback,
                width: _headerHeight,
                color: RevmoColors.petrol,
                iconWidget: SvgPicture.asset(Paths.sortSVG,
                    color: (sortCallback != null) ? Colors.white : Colors.white.withOpacity(RevmoTheme.DIMMING_RATIO)),
                iconPadding: _iconsPadding,
              ),
            ),
          if (!hideFilterbutton)
            Container(
                margin: EdgeInsets.only(left: 1),
                child: RevmoIconButton(
                  callback: filterCallback,
                  width: _headerHeight,
                  color: RevmoColors.originalBlue,
                  iconWidget: SvgPicture.asset(Paths.filtersSVG,
                      color: (filterCallback != null) ? Colors.white : Colors.white.withOpacity(RevmoTheme.DIMMING_RATIO)),
                  iconPadding: _iconsPadding,
                )),
        ],
      ),
    );
  }
}
