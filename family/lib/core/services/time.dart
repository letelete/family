const String monthNames =
    'January|February|March|April|May|June|July|August|September|October|November|December';
const String weekNames =
    'Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday';

extension DateTimeExtensions on DateTime {
  /// Returns [Duration] object of difference between [this] and [compare] date.
  Duration durationBetween(DateTime compare) => this.difference(compare);

  /// Returns [String] data according to given [DateTime] object in a
  /// human-friendly format.
  ///
  /// Template: NameOfWeek, NameOfMonth DayOfMonth
  /// Example: Friday, 21th of November
  String toHuman() {
    final String nameOfWeekday = Time.getWeekdayName(this.weekday);
    final String nameOfMonth = Time.getMonthName(this.month);
    final String dayOfMonth = Time.getOrdinalNumberOfDay(this.day);
    return '$nameOfWeekday, $dayOfMonth of $nameOfMonth';
  }
}

extension DurationExtensions on Duration {
  /// Returns [String] data according to given [Duration] object in a
  /// human-friendly format.
  ///
  /// Template: Days of duration
  /// Examples:
  ///   - 5 days 11 hours 23 seconds -> 5 days
  ///   - 1 day -> tomorrow
  ///   - 0 days -> today
  String toHuman() {
    const Map<int, String> humanDuration = {
      -1: 'Yesterday',
      0: 'Today',
      1: 'Tomorrow',
    };
    int days = this.inDays.abs();

    if (humanDuration.containsKey(days)) {
      return humanDuration[days];
    }

    final String wordAddition = 'days ${this.isNegative ? "ago" : ""}';
    return '$days $wordAddition';
  }
}

class Time {
  /// Returns [DateTime] object of today's day date at function execution time.
  static DateTime now() => DateTime.now();

  /// Returns name of the given month.
  /// January, ..., December
  /// 1, ..., 12
  static String getMonthName(int month) {
    assert(month >= 1 && month <= 12);

    const String delimiter = '|';
    return monthNames.split(delimiter).elementAt(month - 1).toString();
  }

  /// Returns name of the given weekday
  /// Monday, ..., Sunday
  /// 1, ..., 7
  static String getWeekdayName(int day) {
    assert(day >= 1 && day <= 7);

    const String delimiter = '|';
    return weekNames.split(delimiter).elementAt(day - 1).toString();
  }

  /// Returns given day formatted into an ordinal number.
  /// Example: 1 -> 1st
  static String getOrdinalNumberOfDay(int day) {
    const String defaultOrdinal = 'th';
    const Map<int, String> ordinalNumbers = {1: 'st', 2: 'nd', 3: 'rd'};
    return '$day${ordinalNumbers[day] ?? defaultOrdinal}';
  }
}
