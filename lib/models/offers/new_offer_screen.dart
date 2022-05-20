import 'package:flutter/material.dart';
import 'package:revmo/models/offers/offer_request.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revmo/shared/widgets/offers/create_offer_form.dart';

class NewOfferScreen extends StatelessWidget {
  final OfferRequest offerRequest;
  const NewOfferScreen(this.offerRequest);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RevmoAppBar(
        title: AppLocalizations.of(context)!.newOffer,
        subtitle: offerRequest.formatedID,
      ),
      backgroundColor: RevmoColors.darkBlue,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        child: ListView(
          shrinkWrap: true,
          children: [
            NewOfferForm(this.offerRequest)
          ],
        ),
      ),
    );
  }
}
