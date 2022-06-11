import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revmo/providers/Seller/account_provider.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/settings/no_sellers_found.dart';
import 'package:revmo/shared/widgets/settings/user_tile.dart';

class SellersSearchPage extends StatefulWidget {
  final ValueNotifier<String?> searchTextListener;
  const SellersSearchPage({required this.searchTextListener});
  @override
  State<SellersSearchPage> createState() => _SellersSearchPageState();
}

class _SellersSearchPageState extends State<SellersSearchPage> {
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<AccountProvider>(context, listen: false).loadShowroomRequestsAndInvitations(context);
      await loadSearchResutls();
    });
    widget.searchTextListener.addListener(loadSearchResutls);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
        child: NoSellersFound(),
        builder: (cnxt, accountProvider, child) => (_isLoading)
            ? Center(
                child: CircularProgressIndicator(
                color: RevmoColors.originalBlue,
              ))
            : (accountProvider.sellersToAdd != null && accountProvider.sellersToAdd!.isNotEmpty)
                ? ListView.builder(
                    itemCount: accountProvider.sellersToAdd!.length,
                    itemBuilder: (cnxt, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: UserTile(accountProvider.sellersToAdd![index]),
                        ))
                : child!);
  }

  Future loadSearchResutls() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      if (widget.searchTextListener.value != null && widget.searchTextListener.value!.length > 2) {
        await Provider.of<AccountProvider>(context, listen: false).searchSellers(context, widget.searchTextListener.value!);
      } else {
        Provider.of<AccountProvider>(context, listen: false).clearSellersSearch();
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
