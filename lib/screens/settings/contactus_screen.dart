import 'package:flutter/material.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactusScreen extends StatelessWidget {
  const ContactusScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RevmoAppBar(title: AppLocalizations.of(context)!.contactUs,),
    );
  }
}
