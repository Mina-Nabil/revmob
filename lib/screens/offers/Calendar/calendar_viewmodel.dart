import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:revmo/screens/offers/Calendar/calendar_services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../models/offers/calendar_model.dart';
import '../../../models/offers/offer.dart';
import '../../../providers/Seller/account_provider.dart';
import '../CalendarDetails/calendar_details_view.dart';
import 'calendar_view.dart';

class CalendarViewModel extends ViewModel {
  final Offer offer;

  CalendarViewModel({required this.offer});

  CalendarServices _service = CalendarServices();

  Future<bool> createEvent(String title, String note, String location,
      String startDate, String endDate, String notificationTime) {
    EasyLoading.show();
    try {
      return _service
          .createEvents(
              title,
              offer.buyer.id,
              Provider.of<AccountProvider>(context, listen: false).showroom!.id,
              offer.id,
              startDate,
              endDate,
              note,
              location,
              notificationTime)
          .then((value) {
        EasyLoading.dismiss();
        if (value.statusCode == 200) {
          calendarEvents.add(CalendarModel.fromJson(value.data["body"]));
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

  List<CalendarModel> calendarEvents = [];

  bool loading = true;

  Future<List<CalendarModel>> fetchEvents() async {
    return await _service.getEvents(offer.id).then((value) {
      loading = false;
      notifyListeners();
      if (value.statusCode == 200 && value.data["status"]) {
        calendarEvents = List<CalendarModel>.from(
            value.data["body"].map((x) => CalendarModel.fromJson(x)));
        notifyListeners();
        // getDataSource();
        return calendarEvents;
      } else {
        return [];
      }
    });
  }

  List<CalendarModel> getDataSource() {
    List<CalendarModel> meetings = <CalendarModel>[];
    meetings = calendarEvents;
    // notifyListeners();
    return meetings;
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      CalendarModel appointment = calendarTapDetails.appointments![0];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CalendarDetailsPage(
                  appointment: appointment,
                  offer: offer,
                )),
      ).then((value) {
        if(value == "Refresh"){
          fetchEvents();
        }else {}
      });
    }
  }

  Future? _getCalendarFuture;

  Future? get getCalendarFuture => _getCalendarFuture;

  @override
  void init() {
    fetchEvents();
    // TODO: implement init
    super.init();
  }
}
