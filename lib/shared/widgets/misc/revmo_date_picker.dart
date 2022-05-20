import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RevmoDatePicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  RevmoDatePicker({DateTime? currentTime, LocaleType? locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setRightIndex(this.currentTime.year);
    this.setMiddleIndex(this.currentTime.month);
    this.setLeftIndex(this.currentTime.day);
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 2000 && index < 2100) {
      return this.digits(index, 4);
    } else {
      return null;
    }
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 1 && index < 32) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 1 && index <= 12) {
      return this.getMonthName(index);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [2, 2, 2];
  }

  String getMonthName(int index){
    switch (index) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
   
      default:
        return "N/A";
    }
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(this.currentRightIndex(), this.currentMiddleIndex() ,this.currentLeftIndex(), )
        : DateTime(this.currentRightIndex(), this.currentMiddleIndex() ,this.currentLeftIndex(),);
  }
}
