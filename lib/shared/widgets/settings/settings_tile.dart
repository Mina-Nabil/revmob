import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:revmo/shared/theme.dart';

class SettingsTile extends StatelessWidget {
  final String text;
  final String icon;
  final Function()? onTap;
  const SettingsTile({required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      dense: true,
      leading: SvgPicture.asset(
        icon,
        color: Colors.white,
      ),
      title: Align(alignment: Alignment.centerLeft, child: RevmoTheme.getCaption(text, 2)),
      onTap: onTap,
    );
  }
}
