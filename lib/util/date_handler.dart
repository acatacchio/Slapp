import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHandler {
  
  String myDate(int timestamp) {
    String locale = "fr_FR";
    initializeDateFormatting(locale, null);
    DateTime postDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();
    DateFormat format;
    if (now.difference(postDate).inDays > 0) {
      format = DateFormat.yMMMd(locale);
    } else {
      format = DateFormat.Hm(locale);
    }
    return format.format(postDate).toString();
  }
  
}