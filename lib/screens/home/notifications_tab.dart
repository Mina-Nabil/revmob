import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/notification_service.dart';

class NotificationsTab extends StatefulWidget {
  static const screenName = "notificationsTab";

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  Future? _notificationFuture;
  Future? get notificationFuture => _notificationFuture;


  Future refreshMyNotification() async {
    print('refreshing');
  } 

  NotificationService _service =NotificationService();
  Future<bool> getNotification() async {
    try {
      return await _service.getNotification().then((value) {
        if (value.statusCode == 200) {
          // List<Plans> plansResponse = List<Plans>.from(
          //     value.data["body"]["plans"].map((x) => Plans.fromJson(x)));
          // setState(() {
          //   subscriptions = plansResponse;
          // });
          return Future.value(true);
        } else {
          // setState(() {
          //   subscriptions = [];
          // });
          return Future.value(false);
        }
      });
    } catch (e) {
      // setState(() {
      //   subscriptions = [];
      // });
      return Future.value(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: RefreshIndicator(
          onRefresh: refreshMyNotification,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    AppLocalizations.of(context)!.notifications,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10),
                    itemCount: 10,
                    itemBuilder: (context, index) => FadeInUp(
                      child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xff07C5FA).withOpacity(0.2),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: Color(0xff26AEE4),
                            ),
                          ),
                          title: Text(
                            'A new request for Volvo XC90 has been added',
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '2 mins ago',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        FadeInUp(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ).setPageHorizontalPadding(context),
          ),
        ));
  }
}
