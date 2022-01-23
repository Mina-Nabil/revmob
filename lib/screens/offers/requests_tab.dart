import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/home/search_bar.dart';
import 'package:revmo/shared/widgets/misc/revmo_icon_only_button.dart';

class RequestsTab extends StatefulWidget {
  static const String screenName = "requestsTab";
  const RequestsTab();

  @override
  _RequestsTabState createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  final double _iconsPadding = 10;

  bool isLoading = true;
  final TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    //after requests loading
    isLoading=false;
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
                  child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.requests, 3),
                ),
                SizedBox(
                  height: 15,
                ),

                //search & filters
                Container(
                  height: RevmoTheme.SEARCH_BAR_HEIGHT,
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchBar(
                          height: RevmoTheme.SEARCH_BAR_HEIGHT,
                          searchCallback: !isLoading ? setFilters : null,
                          textEditingController: _textEditingController,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3, right: 1),
                        child: RevmoIconButton(
                          callback: (!isLoading) ? sortRequests : null,
                          width: RevmoTheme.SEARCH_BAR_HEIGHT,
                          color: RevmoColors.petrol,
                          iconWidget: SvgPicture.asset(Paths.sortSVG,
                              color: !isLoading ? Colors.white : Colors.white.withOpacity(RevmoTheme.DIMMING_RATIO)),
                          iconPadding: _iconsPadding,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 1),
                          child: RevmoIconButton(
                            callback: !isLoading ? setFilters : null,
                            width: RevmoTheme.SEARCH_BAR_HEIGHT,
                            color: RevmoColors.originalBlue,
                            iconWidget: SvgPicture.asset(Paths.filtersSVG,
                                color: !isLoading ? Colors.white : Colors.white.withOpacity(RevmoTheme.DIMMING_RATIO)),
                            iconPadding: _iconsPadding,
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }

  sortRequests() {}

  setFilters() {}
}
