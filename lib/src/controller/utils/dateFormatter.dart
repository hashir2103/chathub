import 'package:intl/intl.dart';

String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  var formatter = DateFormat('dd/MM/yy');
  return formatter.format(dateTime);
}
