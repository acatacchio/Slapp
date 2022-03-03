import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/constants.dart';
import '../util/date_handler.dart';

class Talk {
  late DocumentReference reference;
  late String text;
  late String date;
  late int intDate;
  late String? userId;
  late bool seen;

  Talk(DocumentSnapshot snap){
    reference = snap.reference;
    Map<String, dynamic> map= snap.data() as Map<String, dynamic>;
    text = map[textKey];
    date = DateHandler().myDate(map[dateKey]);
    intDate = map[dateKey];
    userId = map[uidKey];
    seen = map[seenKey];
  }

}