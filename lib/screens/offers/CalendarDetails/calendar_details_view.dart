import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../models/offers/calendar_model.dart';
import '../../../models/offers/offer.dart';
import '../../../services/toast_service.dart';
import '../../../shared/colors.dart';
import '../../../shared/theme.dart';
import '../../../shared/widgets/home/revmo_appbar.dart';
import 'calendar_details_viewmodel.dart';

class CalendarDetailsPage extends StatelessWidget {
  final Offer offer;
  CalendarModel? appointment;

  CalendarDetailsPage(
      {Key? key, required this.offer, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => CalendarDetailsView(),
      viewModel:
          CalendarDetailsViewModel(offer: offer, appointment: appointment),
    );
  }
}

class CalendarDetailsView extends HookView<CalendarDetailsViewModel> {
  @override
  Widget render(BuildContext context, CalendarDetailsViewModel viewModel) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color:Colors.red, borderRadius: BorderRadius.circular(10)),
        child: InkWell(
            onTap: () {
              viewModel.deleteEvent().then((value) {
                if (value) {
                  Navigator.pop(context, "Refresh");
                }
              });
            },

            child: Text(
              "Delete event",
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.white, fontSize: 16),
            )),
      ),
      backgroundColor: RevmoColors.darkBlue,
      appBar: RevmoAppBar(
        title: "Event Details",
        leading: IconButton(onPressed: (){
          Navigator.pop(context, "Refresh");
        },icon: Icon(Icons.arrow_back_ios_new),),
        actionWidget: Row(
          children: [
            IconButton(
                icon: Icon(
                  Iconsax.edit,
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
                      builder: (context) => EditEvent(viewModel: viewModel));
                }),
            SizedBox(
              width: 10,
            )
          ],
        ),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            viewModel.appointment!.title,
            style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${DateFormat('hh:mm a').format(viewModel.appointment!.start)} - ${DateFormat('hh:mm a').format(viewModel.appointment!.end)}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Iconsax.calendar),
              SizedBox(
                width: 10,
              ),
              if (DateFormat('d MMM y').format(viewModel.appointment!.start) ==
                  DateFormat('d MMM y').format(viewModel.appointment!.end))
                Text(
                  "${DateFormat('d MMM y').format(viewModel.appointment!.start)}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              if (DateFormat('d MMM y').format(viewModel.appointment!.start) !=
                  DateFormat('d MMM y').format(viewModel.appointment!.end))
                Text(
                  "From ${DateFormat('d MMM y').format(viewModel.appointment!.start)} To ${DateFormat('d MMM y').format(viewModel.appointment!.end)}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          // SizedBox(height: 10,),

          SizedBox(
            height: 20,
          ),
          Divider(
            height: 5,
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Participants",
                style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                viewModel.offer.buyer.fullName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.check_circle_sharp,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(
              //   height: mediaQuery.size.height * 0.3,
              //   child: SfCalendar(
              //     view: CalendarView.schedule,
              //     headerHeight: 0,
              //     scheduleViewSettings: ScheduleViewSettings(
              //       appointmentItemHeight: 70,
              //         weekHeaderSettings: WeekHeaderSettings(
              //           height: 0
              //         ),
              //         hideEmptyScheduleWeek: true,
              //         dayHeaderSettings: DayHeaderSettings(
              //             dayFormat: 'EEEE',
              //             width: 70,
              //             dayTextStyle: TextStyle(
              //               fontSize: 10,
              //               fontWeight: FontWeight.w300,
              //               color: Colors.blue,
              //             ),
              //             dateTextStyle: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.w300,
              //               color: Colors.blue,
              //             )),
              //       monthHeaderSettings: MonthHeaderSettings(
              //         height: 0,
              //       )
              //     ),
              //     todayHighlightColor: Colors.blue,
              //     todayTextStyle:
              //         theme.textTheme.bodySmall?.copyWith(color: Colors.black),
              //     minDate: viewModel.initialStartingDate,
              //     maxDate: viewModel.initialEndDate,
              //     // appointmentBuilder: (context, ap) {
              //     //   return Container(
              //     //     // height: 100,
              //     //     width: mediaQuery.size.width,
              //     //     decoration:
              //     //         BoxDecoration(color: Colors.blue.withOpacity(0.8)),
              //     //     child: Center(child: Text(viewModel.appointment!.title)),
              //     //   );
              //     // },
              //     viewHeaderStyle: ViewHeaderStyle(
              //       dayTextStyle:
              //           theme.textTheme.bodyMedium?.copyWith(color: Colors.blue),
              //       dateTextStyle:
              //           theme.textTheme.bodyMedium?.copyWith(color: Colors.blue),
              //     ),
              //     headerStyle: CalendarHeaderStyle(
              //         // backgroundColor: RevmoColors.originalBlue,
              //         textAlign: TextAlign.center,
              //         textStyle: theme.textTheme.bodySmall
              //             ?.copyWith(color: Colors.black, fontSize: 16)),
              //     dataSource: MeetingDataSource(viewModel.getDataSource()),
              //     timeSlotViewSettings: TimeSlotViewSettings(
              //         timeIntervalWidth: 100,
              //         allDayPanelColor: Colors.blue,
              //         timeTextStyle:
              //             theme.textTheme.bodySmall?.copyWith(color: Colors.black)),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Notes",
                style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                viewModel.appointment!.note,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 18,
                   ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            height: 5,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Reminder",
            style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.alarm),
              SizedBox(
                width: 10,
              ),
              Text(
                "${(viewModel.appointment!.notificationTime!.difference(viewModel.appointment!.start).inDays).toString().replaceAll("-", "")} days before",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

        ],
      ).setPageHorizontalPadding(context),
    );
  }
}

class EditEvent extends StatefulWidget {
  final CalendarDetailsViewModel viewModel;

  EditEvent({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  DateTime initialStartingDate = DateTime.now();
  DateTime initialEndDate = DateTime.now();
  final alertController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final notesController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      initialStartingDate = widget.viewModel.initialStartingDate;
      initialEndDate = widget.viewModel.initialEndDate;
      // alertController
      titleController.text = widget.viewModel.appointment!.title;
      locationController.text = widget.viewModel.appointment!.location;
      notesController.text = widget.viewModel.appointment!.note;
    });
    print(initialEndDate);
    super.initState();
  }




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
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                trailing: TextButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        locationController.text.isNotEmpty &&
                        notesController.text.isNotEmpty) {
                      widget.viewModel.EditEvent(
                          titleController.text,
                          notesController.text,
                          locationController.text,
                          initialStartingDate,
                          initialEndDate,
                          // 'Alert me 1 day before',
                          // 'Alert me 2 day before',
                          // 'Alert me 1 week before'

                          initialStartingDate
                              .subtract(Duration(
                              days: alertController.text ==
                                  "Alert me 1 day before"
                                  ? 1
                                  : alertController.text ==
                                  "Alert me 2 day before"
                                  ? 2
                                  : 7))

                      );
                      Navigator.pop(context);
                    } else {
                      ToastService.showErrorToast("Please fill all fields");
                    }
                  },
                ),
                middle: Text(
                  'Edit Event',
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
                            hintText: "Title",
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
                            hintText: "Location",
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
                                      "Starts",
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
                                      "Ends",
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
                                hintText: 'Alert',
                                // fillColor: Colors.red,
                                excludeSelected: true,
                                listItemStyle: theme.textTheme.bodyMedium
                                    ?.copyWith(color: RevmoColors.darkBlue),
                                selectedStyle: theme.textTheme.bodyMedium?.copyWith(
                                    color: RevmoColors.darkBlue,
                                    fontWeight: FontWeight.bold),
                                items: const [
                                  'Alert me 1 day before',
                                  'Alert me 2 day before ',
                                  'Alert me 1 week before'
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
                              hintText: "Notes",
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