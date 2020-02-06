import 'dart:convert';

class DateTimeSerializer extends Converter<Map, DateTime> {
  static const dateKey = 'date';

  @override
  DateTime convert(Map input) {
    if (input == null) {
      print('DateTimeSerializer: The input is null.');
      return null;
    }

    DateTime dateTime;
    try {
      dateTime = DateTime.parse(input[dateKey]);
    } catch (e) {
      print('DateTimeSerializer: Error on parsing date time. ${e.toString()}');
    }

    return dateTime;
  }
}

extension DateTimeToJson on DateTime {
  Map toJson() {
    return <String, dynamic>{
      DateTimeSerializer.dateKey: this.toIso8601String()
    };
  }
}
