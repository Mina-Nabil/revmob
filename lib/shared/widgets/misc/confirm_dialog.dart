import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  final String text;
  final Future Function() ifConfirmedCallback;
  const ConfirmDialog(this.text, this.ifConfirmedCallback);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.pleaseConfirm),
      content: Container(
        height: 60,
        width: 60,
        child: FittedBox(child: Text(AppLocalizations.of(context)!.areYouSure + " " + text)),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(AppLocalizations.of(context)!.no)),
        TextButton(
            onPressed: () async => await ifConfirmedCallback().whenComplete(() => Navigator.of(context).pop()),
            child: Text(AppLocalizations.of(context)!.confirm)),
      ],
    );
  }
}
