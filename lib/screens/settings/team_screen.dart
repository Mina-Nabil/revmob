import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/default_header.dart';
import 'package:revmo/shared/widgets/misc/titles_row.dart';
import 'package:revmo/shared/widgets/settings/sellers_search_page.dart';
import 'package:revmo/shared/widgets/settings/team_page.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen();

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  TextEditingController _searchController = new TextEditingController();
  ValueNotifier<String?> _searchNotifier = new ValueNotifier<String?>(null);
  PageController _pageController = new PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: RevmoAppBar(
            title: AppLocalizations.of(context)!.team,
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: RevmoColors.darkBlue,
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                RevmoDefaultHeader(
                  searchCallback: searchSellers,
                  searchTextController: _searchController,
                  hideFilterbutton: true,
                  hideSortbutton: true,
                  searchHint: (currentPage == 1) ? AppLocalizations.of(context)!.searchAllSellers : null,
                ),
                TitlesRow({
                  AppLocalizations.of(context)!.yourTeam: () {
                    setState(() {
                      currentPage = 0;
                    });
                    _pageController.animateToPage(0, duration: RevmoTheme.PAGES_DURATION, curve: RevmoTheme.PAGES_CURVE);
                  },
                  AppLocalizations.of(context)!.addToSalesTeam: () {
                    setState(() {
                      currentPage = 1;
                    });
                    _pageController.animateToPage(1, duration: RevmoTheme.PAGES_DURATION, curve: RevmoTheme.PAGES_CURVE);
                  },
                }, currentPage),
                Expanded(
                  child: PageView(
                    // physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    controller: _pageController,
                    children: [
                      TeamPage(searchTextListener: _searchNotifier),
                      SellersSearchPage(searchTextListener: _searchNotifier)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  searchSellers() {
    _searchNotifier.value = _searchController.text;
  }
}
