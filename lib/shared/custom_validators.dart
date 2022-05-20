import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension CustomValidators on ValidationBuilder {

  fullName(BuildContext context) => add((input) {
        if(input == null) return AppLocalizations.of(context)!.fieldReqMsg;
        if (input.split(" ").length < 2) return AppLocalizations.of(context)!.fullNameMin2Msg;
        if (input.length < 6) return AppLocalizations.of(context)!.any6MinLength;
        if (input.length > 60) return AppLocalizations.of(context)!.fullNameLengthOverMsg;
      });

  number(BuildContext context) => add((input){
     if(input == null) return AppLocalizations.of(context)!.fieldReqMsg;
     if(double.tryParse(input) == null) return AppLocalizations.of(context)!.numberInvalidMsg;
  });
}
