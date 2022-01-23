import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/account_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/settings/no_showroom_found.dart';
import 'package:revmo/shared/widgets/settings/showroom_tile.dart';
import 'package:revmo/shared/widgets/settings/user_tile.dart';

class ShowroomSearchPage extends StatefulWidget {
  final ValueNotifier<String?> searchTextListener;
  const ShowroomSearchPage({required this.searchTextListener});
  @override
  State<ShowroomSearchPage> createState() => _ShowroomSearchPageState();
}

class _ShowroomSearchPageState extends State<ShowroomSearchPage> {
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<AccountProvider>(context, listen: false).loadSellerRequestsAndInvitations(context);
      await loadSearchResutls();
    });
    widget.searchTextListener.addListener(loadSearchResutls);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
        child: NoShowroomsFound(),
        builder: (cnxt, accountProvider, child) => (_isLoading)
            ? Center(
                child: CircularProgressIndicator(
                color: RevmoColors.originalBlue,
              ))
            : (accountProvider.showroomToAdd != null && accountProvider.showroomToAdd!.isNotEmpty)
                ? ListView.builder(
                    itemCount: accountProvider.showroomToAdd!.length,
                    itemBuilder: (cnxt, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ShowroomTile(accountProvider.showroomToAdd![index]),
                        ))
                : child!);
  }

  Future loadSearchResutls() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      if (widget.searchTextListener.value != null && widget.searchTextListener.value!.length > 2) {
        await Provider.of<AccountProvider>(context, listen: false).searchShowrooms(context, widget.searchTextListener.value!);
      } else {
        Provider.of<AccountProvider>(context, listen: false).clearShowroomsSearch();
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      Provider.of<AccountProvider>(context, listen: false).clearSellersSearch();
    }
  }

  @override
  void dispose() {
    widget.searchTextListener.removeListener(loadSearchResutls);
    super.dispose();
  }
}
