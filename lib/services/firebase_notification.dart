import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseCustomNotification {


  firebaseSub() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
 


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data.toString());
    });
  }



}