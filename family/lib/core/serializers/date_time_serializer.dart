import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeSerializer extends Converter<Timestamp, DateTime> {
  @override
  DateTime convert(Timestamp input) {
    if (input == null) {
      print('DateTimeSerializer: The input is null.');
      return null;
    }
    DateTime dateTime;
    try {
      dateTime = input.toDate().toLocal();
    } catch (e) {
      print('DateTimeSerializer: Error on parsing date time. ${e.toString()}');
    }
    return dateTime;
  }
}

extension DateTimeToJson on DateTime {
  Timestamp toJson() {
    final utc = this.toUtc();
    return Timestamp.fromDate(utc);
  }
}
