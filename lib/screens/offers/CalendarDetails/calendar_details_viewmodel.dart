
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pmvvm/pmvvm.dart';

import '../../../models/offers/calendar_model.dart';
import '../../../models/offers/offer.dart';
import 'calendar_details_service.dart';

class CalendarDetailsViewModel extends ViewModel {
  final Offer offer;
  CalendarModel? appointment;

  CalendarDetailsViewModel({required this.offer, this.appointment});

  DateTime initialStartingDate = DateTime.now();
  DateTime initialEndDate = DateTime.now();

  CalendarDetailServices _services = CalendarDetailServices();

  bool startExpand = false;

  setStartExpand(bool value) {
    startExpand = value;
    notifyListeners();
  }

  bool endExpand = false;

  setEndExpand(bool value) {
    endExpand = value;
    notifyListeners();
  }

  Future<bool> deleteEvent() {
    EasyLoading.show();
    try {
      return _services
          .deleteEvent(appointment!.id
      )
          .then((value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          notifyListeners();
          return Future.value(true);
        } else {
          notifyListeners();
          return Future.value(false);
        }
      });
    } on DioError catch (e) {
      EasyLoading.dismiss();
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> EditEvent(String title, String note, String location,
      DateTime startDate, DateTime endDate, DateTime notificationTime) {
    EasyLoading.show();
    try {
      return _services
          .editEvent(
          title,
          startDate.toString(),
          endDate.toString(),
          note,
          location,
          notificationTime.toString(),
          appointment!.id)
          .then((value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          appointment!.title = title;
          appointment!.start = startDate;
          appointment!.end = endDate;
          appointment!.note = note;
          appointment!.notificationTime = notificationTime;
          notifyListeners();
          return Future.value(true);
        } else {
          notifyListeners();
          return Future.value(false);
        }
      });
    } on DioError catch (e) {
      EasyLoading.dismiss();
      print(e);
      return Future.value(false);
    }
  }


}
