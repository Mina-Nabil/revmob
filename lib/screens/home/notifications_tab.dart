import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:revmo/models/Notification/notification_model.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as smart;

import '../../environment/paths.dart';
import '../../services/notification_service.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/misc/not_found_widget.dart';

class NotificationsTab extends StatefulWidget {
  static const screenName = "notificationsTab";

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  NotificationService _service = NotificationService();

  Future? _notificationFuture;

  Future? get notificationFuture => _notificationFuture;

  Future refreshMyNotification() async {
    print('refreshing');
  }

  List<NotificationModel> _notificationList = [];

  List<NotificationModel> get notificationList => _notificationList;

  int currentPageHistory = 1;
  final smartRefresh = smart.RefreshController();

  Future<dynamic> getNotification() async {
    try {
      return await _service.getNotification().then((value) {
        if (value.statusCode == 200) {
          _notificationList.clear();
          setState(() {
            currentPageHistory = 1;
          });
          List<NotificationModel> response = List<NotificationModel>.from(
              value.data["data"].map((x) => NotificationModel.fromJson(x)));
          setState(() {
            _notificationList = response;
          });
          setState(() {
            currentPageHistory++;
            smartRefresh.refreshCompleted();
          });

          return Future.value(true);
        } else {
          smartRefresh.refreshCompleted();

          return Future.value(false);
        }
      });
    } catch (e) {
      smartRefresh.refreshCompleted();

      return Future.value(false);
    }
  }

  Future<bool> fetchNextPage() async {
    try {
      return await _service.getNextPage(currentPageHistory).then((value) {
        if (value.statusCode == 200) {
          List<NotificationModel> responsePaginated =
              List<NotificationModel>.from(
                  value.data["data"].map((x) => NotificationModel.fromJson(x)));
          if (responsePaginated.isEmpty) {
          } else {
            setState(() {
              currentPageHistory++;
              _notificationList.addAll(responsePaginated);
            });
          }
          smartRefresh.loadComplete();
          return Future.value(true);
        } else {
          smartRefresh.loadComplete();
          return Future.value(false);
        }
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    setState(() {
      _notificationFuture = getNotification();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   child: Text(
            //     AppLocalizations.of(context)!.notifications,
            //     style: TextStyle(fontSize: 20),
            //   ),
            // ),
            Container(
              width: double.infinity,
              child: RevmoTheme.getSemiBold( AppLocalizations.of(context)!.notifications, 3),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                  future: notificationFuture,
                  builder: (context, connectionState) {
                    if (connectionState.connectionState ==
                        ConnectionState.done) {
                      if (notificationList.isEmpty) {
                        return FadeInUp(
                          child: Center(
                              child: LayoutBuilder(
                                  builder: (context, constraints) =>
                                      ListView(children: [
                                        Container(
                                            alignment: Alignment.center,
                                            height: constraints.maxHeight,
                                            child: Center(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                  SvgPicture.asset(
                                                    Paths.noCustomersSVG,
                                                    color:
                                                        RevmoColors.darkerBlue,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  FittedBox(
                                                    child:
                                                        RevmoTheme.getSemiBold(
                                                            "No Notifications",
                                                            2,
                                                            color: RevmoColors
                                                                .originalBlue),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),

                                                ])))
                                      ]))
                              // fetchCustomers
                              ),
                        );
                      } else {
                        return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: smart.SmartRefresher(
                              controller: smartRefresh,
                              enablePullUp: true,
                              onLoading: () async {
                                fetchNextPage().then((value) {
                                  if (value) {
                                    smartRefresh.loadComplete();
                                  } else {
                                    smartRefresh.loadComplete();
                                  }
                                });
                              },
                              onRefresh: () async {
                                smartRefresh.loadComplete();
                                HapticFeedback.lightImpact();
                                return getNotification();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  itemCount: notificationList.length,
                                  itemBuilder: (context, index) => FadeInUp(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Color(0xff07C5FA)
                                                .withOpacity(0.2),
                                            child: Icon(
                                              Icons.notifications_outlined,
                                              color: Color(0xff26AEE4),
                                            ),
                                          ),
                                          title: Text(
                                            notificationList[index].body!,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                DateFormat('dd-MM-yyyy').format(
                                                    DateTime.parse(
                                                        notificationList[index]
                                                            .createdAt!)),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          FadeInUp(
                                    child: Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ));
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ).setPageHorizontalPadding(context));
  }
}
