import 'package:flutter/material.dart';
import 'package:revmo/services/auth_service.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/widgets/misc/main_button.dart';

class NotificationsTab extends StatelessWidget {
  static const screenName = "notificationsTab";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: Column(
          children: [
            Container(
              child: Text("Ana notifications"),
            ),

          ],
        ));
  }
}
