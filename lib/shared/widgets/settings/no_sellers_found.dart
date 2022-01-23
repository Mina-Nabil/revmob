import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/environment/paths.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoSellersFound extends StatelessWidget {
  const NoSellersFound();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              Paths.groupLargeSVG,
              color: RevmoColors.darkestBlue,
            ),
          ),
        ),
        SizedBox(height: 12,),
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            child: RevmoTheme.getSemiBold(AppLocalizations.of(context)!.noUsersFound, 2)),
        ),
      ],
    );
  }
}
