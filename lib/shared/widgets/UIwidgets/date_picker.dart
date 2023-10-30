// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// class DataPicker extends StatefulWidget {
//   DataPicker({Key? key, }) : super(key: key);
//
//   @override
//   State<DataPicker> createState() => _DataPickerState();
// }
//
// class _DataPickerState extends State<DataPicker> {
//   TextEditingController dataPickerInput = TextEditingController();
//   String selectedDate = '';
//   String dateCount = '';
//   String range = '';
//   String endrange = ' ';
//   String rangeCount = '';
//
//   void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       if (args.value is PickerDateRange) {
//         range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)}';
//         endrange =
//         ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
//         print(range);
//         setState(() {
//           dataPickerInput.text = range;
//         });
//       } else if (args.value is DateTime) {
//         print(selectedDate);
//
//         setState(() {
//           selectedDate = DateFormat('dd/MM/yyyy').format(args.value);
//           dataPickerInput.text = selectedDate;
//           print(selectedDate);
//         });
//       } else if (args.value is List<DateTime>) {
//         dateCount = args.value.length.toString();
//       } else {
//         rangeCount = args.value.length.toString();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     var theme = Theme.of(context);
//     return Container(
//       width: mediaQuery.size.width,
//       child: TextField(
//           controller: dataPickerInput,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 15,
//           ),
//           decoration: InputDecoration(
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: Colors.black),
//             ),
//             // labelText: widget.SubmitParametersObj.label,
//             floatingLabelStyle: TextStyle(
//               color: Color(0xff9D9C9C),
//             ),
//             labelStyle: theme.textTheme.bodyMedium?.copyWith(
//               fontSize: 15,
//               color: Color(0xff9D9C9C),
//             ),
//             suffixIcon: Image.asset(
//               "assets/images/Services/icn_ calendar.png",
//               scale: 2.5,
//             ),
//           ),
//           readOnly: true,
//           onTap: () async {
//             setState(() {
//
//             });
//             await showModalBottomSheet(
//
//                 context: context,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(25.0),
//                   ),
//                 ),
//                 isDismissible: false,
//                 isScrollControlled:true,
//                 builder: (BuildContext context) {
//                   return FractionallySizedBox(
//                     heightFactor: 0.7,
//                     child: StatefulBuilder(
//                       builder: (context, setState) => ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Scaffold(
//                           appBar: AppBar(
//                             title: Text(
//                               'Select date',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 color: Color(0xff505050),
//                               ),
//                             ),
//                             automaticallyImplyLeading: false,
//                             backgroundColor: Colors.transparent,
//                             elevation: 0,
//                             actions: [
//                               MaterialButton(
//                                 onPressed: () {
//                                   FocusScope.of(context)
//                                       .requestFocus(new FocusNode());
//                                   Navigator.pop(context);
//                                 },
//                                 minWidth: 20,
//                                 child: Image.asset(
//                                   "assets/images/Services/icn_closepng.png",
//                                   color: Colors.black,
//                                   scale: 2.5,
//                                 ),
//                               )
//                             ],
//                           ),
//                           body: Container(
//                             padding:const  EdgeInsets.all(15),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.white,
//                             ),
//                             // height: mediaQuery.size.height * 0.8,
//                             child: Column(
//                               children: [
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   height: MediaQuery.of(context).size.height * 0.4,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                         color: Colors.grey.shade300, width: 1.5),
//                                   ),
//                                   child: SfDateRangePicker(
//                                     onSubmit: (v){
//                                       setState(() {
//
//                                       });
//                                     },
//                                     startRangeSelectionColor: Color(0xffE00800),
//                                     endRangeSelectionColor: Color(0xffE00800),
//                                     rangeSelectionColor: Color(0xffFDEBEB),
//                                     selectionColor: Color(0xffE00800),
//                                     headerHeight: 60,
//                                     showNavigationArrow: true,
//                                     monthViewSettings:
//                                     DateRangePickerMonthViewSettings(
//                                       viewHeaderHeight: 50,
//                                       dayFormat: "E",
//                                       firstDayOfWeek: 6,
//                                       weekendDays: [5, 6],
//                                       viewHeaderStyle: DateRangePickerViewHeaderStyle(
//                                         backgroundColor: Color(0xffF5F5F1),
//                                       ),
//                                     ),
//                                     onSelectionChanged:(args){
//                                       // onSelectionChanged(args);
//                                       setState(() {
//                                         selectedDate = DateFormat('dd/MM/yyyy').format(args.value);
//                                         dataPickerInput.text = selectedDate;                                    });
//
//                                     } ,
//                                     selectionMode:
//                                     DateRangePickerSelectionMode.single,
//                                     // enablePastDates: false,
//                                     headerStyle: DateRangePickerHeaderStyle(
//                                       textAlign: TextAlign.center,
//                                       textStyle: TextStyle(
//                                         fontSize: 20,
//                                         color: Color(0xff505050),
//                                       ),
//                                     ),
//                                     monthCellStyle: DateRangePickerMonthCellStyle(
//                                       weekendTextStyle:
//                                       TextStyle(color: Colors.grey, fontSize: 16),
//                                       todayTextStyle: TextStyle(
//                                           color: Color(0xffC0A365), fontSize: 16),
//                                       textStyle: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     selectionTextStyle:
//                                     TextStyle(color: Colors.white),
//                                     todayHighlightColor: Color(0xffC0A365),
//                                     initialSelectedRange: PickerDateRange(
//                                         DateTime.now()
//                                             .subtract(const Duration(days: 0)),
//                                         DateTime.now().add(const Duration(days: 0))),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           floatingActionButton: SizedBox(
//                             height: mediaQuery.size.height * 0.06,
//                             width: mediaQuery.size.width * 0.9,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: selectedDate.isEmpty
//                                     ? Color(0xffDBDBDB)
//                                     : Colors.black,
//                                 textStyle: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 17,
//                                     fontStyle: FontStyle.normal),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.all(Radius.circular(25))),
//                               ),
//                               onPressed: () {
//                                 if(selectedDate.isEmpty){}else {
//                                   Navigator.pop(context);
//
//                                 }
//                               },
//                               child: IgnorePointer(
//                                   ignoring: selectedDate.isEmpty ? true : false,
//                                   child: Text("Apply")),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                     ),
//                   );
//                 });
//           }),
//     );
//   }
// }
