import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/account_provider.dart';
import 'package:revmo/screens/home/home_screen.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/misc/default_header.dart';
import 'package:revmo/shared/widgets/misc/titles_row.dart';
import 'package:revmo/shared/widgets/settings/showrooms_search_page.dart';

class JoinShowroomScreen extends StatefulWidget {
  static const String ROUTE_NAME = "join/showroom";
  const JoinShowroomScreen();

  @override
  _JoinShowroomScreenState createState() => _JoinShowroomScreenState();
}

class _JoinShowroomScreenState extends State<JoinShowroomScreen> {
  TextEditingController _searchController = new TextEditingController();
  ValueNotifier<String?> _searchNotifier = new ValueNotifier<String?>(null);
  int currentPage = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<AccountProvider>(context, listen: false).loadUser(context, forceReload: true);
      if (Provider.of<AccountProvider>(context, listen: false).showroom != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.ROUTE_NAME, ModalRoute.withName('/'));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: RevmoAppBar(
            title: AppLocalizations.of(context)!.showrooms,
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
                  AppLocalizations.of(context)!.joinShowroom: null,
                }, currentPage),
                Expanded(child: ShowroomSearchPage(searchTextListener: _searchNotifier)),
              ],
            ),
          ),
        ));
  }

  searchSellers() {
    _searchNotifier.value = _searchController.text;
  }
}
