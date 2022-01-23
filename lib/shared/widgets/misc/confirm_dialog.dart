import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDialog extends StatefulWidget {
  final String text;
  final Future Function() ifConfirmedCallback;
  const ConfirmDialog(this.text, this.ifConfirmedCallback);

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool disableButtons = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.pleaseConfirm),
      content: Container(
        height: 60,
        width: 60,
        child: FittedBox(child: Text(AppLocalizations.of(context)!.areYouSure + " " + widget.text)),
      ),
      actions: [
        TextButton(
            onPressed: !disableButtons
                ? () {
                    Navigator.of(context).pop(false);
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.no)),
        TextButton(
            onPressed: !disableButtons
                ? () async {
                    setState(() {
                      disableButtons = true;
                    });
                    await widget
                        .ifConfirmedCallback()
                        .whenComplete(() => Navigator.of(context).pop())
                        .onError((error, stackTrace) => setState(() {
                              disableButtons = true;
                            }));
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.confirm)),
      ],
    );
  }
}
