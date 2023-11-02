import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:revmo/services/toast_service.dart';
import 'package:revmo/shared/widgets/home/revmo_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../models/offers/calendar_model.dart';
import '../../../models/offers/offer.dart';
import '../../../shared/colors.dart';
import '../../../shared/theme.dart';
import 'calendar_viewmodel.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';


class CalendarPage extends StatelessWidget {
  final Offer offer;

  const CalendarPage({Key? key, required this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => CalendarPageView(),
      viewModel: CalendarViewModel(offer: offer),
    );
  }
}

class CalendarPageView extends HookView<CalendarViewModel> {
  @override
  Widget render(BuildContext context, CalendarViewModel viewModel) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    print(viewModel.offer.seller.showroom);

    return Material(
      child: Scaffold(
        backgroundColor: RevmoColors.darkBlue,
        appBar: RevmoAppBar(
          title: AppLocalizations.of(context)!.calendar,
          actionWidget: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Iconsax.add_circle5,
                  ),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                        expand: true,
                        isDismissible: false,
                        enableDrag: false,
                        elevation: 10,
                        useRootNavigator: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AddEvent(viewModel: viewModel));
                  }),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        body:
        viewModel.loading ? Center(child: CircularProgressIndicator()) :
        FadeIn(
          child: SfCalendar(
            onTap: viewModel.calendarTapped,
            // onTap: (v){
            //   var data = v.appointments as List<CalendarModel>;
            //   print(data[0].id);
            // },
            backgroundColor: Colors.white,
            viewHeaderHeight: 50,
            todayHighlightColor: Colors.blue,
            weekNumberStyle: WeekNumberStyle(
                backgroundColor: Colors.black,
                textStyle: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.black)),
            appointmentTextStyle:
            theme.textTheme.bodySmall!.copyWith(color: Colors.white),
            viewHeaderStyle: ViewHeaderStyle(
              backgroundColor: const Color(0xffF5FBFE),
              dateTextStyle:
              theme.textTheme.bodySmall?.copyWith(color: Colors.black),
              dayTextStyle: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            todayTextStyle:
            theme.textTheme.bodySmall?.copyWith(color: Colors.white),
            viewNavigationMode: ViewNavigationMode.none,
            showCurrentTimeIndicator: true,
            showNavigationArrow: true,
            initialDisplayDate: DateTime.now(),
            initialSelectedDate: DateTime.now(),
            headerStyle: CalendarHeaderStyle(
                backgroundColor: Colors.white,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            view: CalendarView.month,
            cellBorderColor: RevmoColors.grey.withOpacity(0.1),
            dataSource: MeetingDataSource(viewModel.getDataSource()),
            selectionDecoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 0.4)),
            cellEndPadding: 0,
            monthViewSettings: MonthViewSettings(
                showAgenda: true,
                appointmentDisplayCount: 1,
                agendaViewHeight: mediaQuery.size.height * 0.25,
                agendaStyle: AgendaStyle(
                    backgroundColor: const Color(0xffF3FAFF),
                    appointmentTextStyle: theme.textTheme.bodySmall
                        ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.5),
                    dateTextStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    dayTextStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                showTrailingAndLeadingDates: true,
                monthCellStyle: const MonthCellStyle(
                  todayBackgroundColor: Color(0xffF5FBFE),
                  trailingDatesTextStyle: TextStyle(color: Colors.grey),
                  leadingDatesTextStyle: TextStyle(color: Colors.grey),
                  textStyle: TextStyle(color: Colors.black),
                ),
                appointmentDisplayMode:
                MonthAppointmentDisplayMode.appointment),
          ),
        ),
      ),
    );
  }
}

class AddEvent extends StatefulWidget {
  final CalendarViewModel viewModel;

  AddEvent({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime initialStartingDate = DateTime.now();
  DateTime initialEndDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      initialEndDate = initialStartingDate.add(Duration(hours: 1));
    });
    print(initialEndDate);
    super.initState();
  }


  final alertController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final notesController = TextEditingController();

  bool startExpand = false;

  setStartExpand(bool value) {
    setState(() {
      startExpand = value;
    });
  }

  bool endExpand = false;

  setEndExpand(bool value) {
    setState(() {
      endExpand = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Material(
        child: GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        setStartExpand(false);
        setEndExpand(false);
      },
      child: CupertinoPageScaffold(
        backgroundColor: Color(0xffEBEAEE),
        navigationBar: CupertinoNavigationBar(
            border: Border.all(color: Colors.transparent),
            backgroundColor: Color(0xffEBEAEE),
            leading: TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            trailing: TextButton(
              child: Text(AppLocalizations.of(context)!.add),
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    locationController.text.isNotEmpty &&
                    notesController.text.isNotEmpty) {
                  widget.viewModel.createEvent(
                      titleController.text,
                      notesController.text,
                      locationController.text,
                      initialStartingDate.toString(),
                      initialEndDate.toString(),
                      // 'Alert me 1 day before',
                      // 'Alert me 2 day before',
                      // 'Alert me 1 week before'

                      initialStartingDate
                          .subtract(Duration(
                              days: alertController.text ==
                                  AppLocalizations.of(context)!.alertMe1DayBefore
                                  ? 1
                                  : alertController.text ==
                                  AppLocalizations.of(context)!.alertMe2DayBefore
                                      ? 2
                                      : 7))
                          .toString()
                      );
                  Navigator.pop(context);
                } else {
                  ToastService.showErrorToast(AppLocalizations.of(context)!.pleaseFillAllFields);
                }
              },
            ),
            middle: Text(
              AppLocalizations.of(context)!.newEvent,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: RevmoColors.darkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )),
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            physics: ClampingScrollPhysics(),
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: mediaQuery.size.width,
                // height: 100,
                padding: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    TextFormField(
                      style: RevmoTheme.getBodyStyle(1,
                          color: RevmoColors.darkBlue),
                      controller: titleController,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.title,
                        hintStyle: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.black.withOpacity(0.5)),
                        // label: Text("Title")
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    TextFormField(
                      style: RevmoTheme.getBodyStyle(1,
                          color: RevmoColors.darkBlue),
                      controller: locationController,
                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.location,
                        hintStyle: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.black.withOpacity(0.5)),
                        // label: Text("Title")
                      ),
                    ),
                  ],
                ).setPageHorizontalPadding(context),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: mediaQuery.size.width,
                // height: 100,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "All day",
                    //       style: theme.textTheme.bodyMedium
                    //           ?.copyWith(color: Colors.black),
                    //     ),
                    //     CustomSwitch(
                    //         onToggle: (v) {
                    //           setAllDay(v);
                    //         },
                    //         value: allDayEvent)
                    //   ],
                    // ),
                    // Divider(
                    //   color: Colors.grey,
                    // ),
                    AnimatedContainer(
                      height: startExpand ? 222 : 35,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setStartExpand(!startExpand);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.starts,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(color: RevmoColors.darkBlue),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        DateFormat('d MMM y')
                                            .format(initialStartingDate),
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Text(
                                    //   "${initialStartingDate.toLocal()}"
                                    //       .split(' ')[0],
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        "${DateFormat('hh:mm a').format(initialStartingDate)}",
                                        // .split(' ')[1],
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (startExpand)
                            FadeIn(
                              child: Container(
                                height: 190,
                                color: Color.fromARGB(255, 255, 255, 255),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 180,
                                      child: CupertinoTheme(
                                        data: CupertinoThemeData(
                                          textTheme: CupertinoTextThemeData(
                                              pickerTextStyle: TextStyle(
                                            color: Color(0xffB59CCF),
                                          )),
                                        ),
                                        child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            minimumDate: DateTime.now(),
                                            // initialDateTime: initialStartingDate,
                                            onDateTimeChanged: (val) {
                                              print(val);
                                              setState(() {
                                                initialStartingDate = val;
                                                initialEndDate =
                                                    val.add(Duration(hours: 1));
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Divider(
                      color: Colors.grey,
                    ),

                    AnimatedContainer(
                      // height: 35,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setEndExpand(!endExpand);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.ends,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(color: RevmoColors.darkBlue),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        DateFormat('d MMM y')
                                            .format(initialEndDate),
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    // Text(
                                    //   "${initialStartingDate.toLocal()}"
                                    //       .split(' ')[0],
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 14,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        "${DateFormat('hh:mm a').format(initialEndDate)}",
                                        // .split(' ')[1],
                                        style: TextStyle(
                                            color: RevmoColors.darkBlue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (endExpand)
                            FadeIn(
                              child: Container(
                                height: 190,
                                color: Color.fromARGB(255, 255, 255, 255),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 180,
                                      child: CupertinoTheme(
                                        data: CupertinoThemeData(
                                          textTheme: CupertinoTextThemeData(
                                              pickerTextStyle: TextStyle(
                                            color: Color(0xffB59CCF),
                                          )),
                                        ),
                                        child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            minimumDate: initialStartingDate
                                                .add(Duration(hours: 1)),
                                            initialDateTime: initialStartingDate
                                                .add(Duration(hours: 1)),
                                            maximumDate: initialStartingDate
                                                .add(Duration(hours: 8)),
                                            onDateTimeChanged: (val) {
                                              print(val);
                                              setState(() {
                                                initialEndDate = val;
                                              });
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ).setPageHorizontalPadding(context),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: mediaQuery.size.width,
                // height: 100,
                // padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(
                        //   "Alert",
                        //   style: theme.textTheme.bodyMedium
                        //       ?.copyWith(color: Colors.black),
                        // ),
                        SizedBox(
                          width: mediaQuery.size.width * 0.88,
                          child: CustomDropdown(
                            hintText: AppLocalizations.of(context)!.alert,
                            // fillColor: Colors.red,
                            excludeSelected: true,
                            listItemStyle: theme.textTheme.bodyMedium
                                ?.copyWith(color: RevmoColors.darkBlue),
                            selectedStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: RevmoColors.darkBlue,
                                fontWeight: FontWeight.bold),
                            items:  [
                              AppLocalizations.of(context)!.alertMe1DayBefore,
                              AppLocalizations.of(context)!.alertMe2DayBefore,
                              AppLocalizations.of(context)!.alertMe1WeekBefore
                            ],
                            controller: alertController,
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  width: mediaQuery.size.width,
                  // height: 100,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      TextFormField(
                        style: RevmoTheme.getBodyStyle(1,
                            color: RevmoColors.darkBlue),
                        controller: notesController,
                        decoration: InputDecoration(
                          isDense: true,
                          focusedBorder: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.notes,
                          hintStyle: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ).setPageHorizontalPadding(context)),
            ],
          ).setPageHorizontalPadding(context),
        ),
      ),
    ));
  }
}

class CustomSwitch extends StatelessWidget {
  bool value;
  Function(bool) onToggle;

  CustomSwitch({Key? key, required this.onToggle, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
        width: 55,
        height: 30,
        inactiveColor: Colors.grey,
        inactiveToggleColor: Colors.white,
        activeColor: Colors.green,
        activeToggleColor: Colors.white,
        toggleSize: 30.0,
        value: value,
        borderRadius: 30.0,
        padding: 1,
        showOnOff: false,
        onToggle: onToggle);
  }
}

class MeetingDataSource extends CalendarDataSource {

  MeetingDataSource(List<CalendarModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].start;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].end;
  }
  @override
  DateTime getNotificationTime(int index) {
    return appointments![index].notificationTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  int getId(int index) {
    return appointments![index].id;
  }

  @override
  String getNote(int index) {
    return appointments![index].note;
  }


}




