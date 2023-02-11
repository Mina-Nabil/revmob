import 'package:intl/intl.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.capitalize()).join(' ');
}


extension DateTimeFormater on DateTime {
  String dateFormatter() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

}