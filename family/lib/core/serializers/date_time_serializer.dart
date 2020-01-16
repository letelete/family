import 'dart:convert';

const _date = 'date';

class DateTimeSerializer extends Converter<Map, DateTime> {
  @override
  DateTime convert(Map input) {
    if (input == null) {
      print('DateTimeSerializer: The input is null.');
      return null;
    }

    DateTime dateTime;
    try {
      dateTime = DateTime.parse(input[_date]);
    } catch (e) {
      print('DateTimeSerializer: Error on parsing date time. ${e.toString()}');
    }

    return dateTime;
  }
}

extension DateTimeToJson on DateTime {
  Map toJson() {
    return <String, dynamic>{_date: this.toIso8601String()};
  }
}
