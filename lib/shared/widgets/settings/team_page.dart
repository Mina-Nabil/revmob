import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/shared/widgets/settings/no_sellers_found.dart';
import 'package:revmo/shared/widgets/settings/user_tile.dart';

class TeamPage extends StatefulWidget {
  final ValueNotifier<String?> searchTextListener;
  const TeamPage({required this.searchTextListener});
  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  bool isLoading = true;
  DateTime lastRefresh = DateTime.now();
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<AccountProvider>(context, listen: false).loadTeam(context);
      lastRefresh = DateTime.now();
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshTeamList,
      child: Consumer<AccountProvider>(
        child: NoSellersFound(),
        builder: (cnxt, accountProvider, child) => ValueListenableBuilder<String?>(
            child: child,
            valueListenable: widget.searchTextListener,
            builder: (cnxt, searchText, child) => (accountProvider.team != null &&
                    accountProvider.team!.where((seller) => searchText == null || seller.contains(searchText)).isNotEmpty)
                ? ListView.builder(
                    itemCount: accountProvider.team!.length, itemBuilder: (cnxt, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: UserTile(accountProvider.team![index]),
                    ))
                : child!),
      ),
    );
  }

  Future refreshTeamList() async {
    if (DateTime.now().difference(lastRefresh).inSeconds > 5) {
      await Provider.of<AccountProvider>(context, listen: false).loadTeam(context, forceReload: true);
      lastRefresh = DateTime.now();
    }
  }
}
