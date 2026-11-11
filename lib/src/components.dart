/// Date and time parts, the equivalent of the plain objects returned by the
/// JS package (`{year, month, day, hour, minute, second}`).
class DateTimeComponents {
  int year;
  int month;
  int day;
  int hour;
  int minute;
  int second;

  DateTimeComponents(
      this.year, this.month, this.day, this.hour, this.minute, this.second);

  Map<String, int> toMap() => {
        'year': year,
        'month': month,
        'day': day,
        'hour': hour,
        'minute': minute,
        'second': second,
      };

  @override
  bool operator ==(Object other) =>
      other is DateTimeComponents &&
      other.year == year &&
      other.month == month &&
      other.day == day &&
      other.hour == hour &&
      other.minute == minute &&
      other.second == second;

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute, second);

  @override
  String toString() => 'DateTimeComponents${toMap()}';
}

class DateComponents {
  final int year;
  final int month;
  final int day;

  const DateComponents(this.year, this.month, this.day);

  Map<String, int> toMap() => {'year': year, 'month': month, 'day': day};

  @override
  bool operator ==(Object other) =>
      other is DateComponents &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'DateComponents${toMap()}';
}

class TimeComponents {
  final int hour;
  final int minute;
  final int second;

  const TimeComponents(this.hour, this.minute, this.second);

  Map<String, int> toMap() =>
      {'hour': hour, 'minute': minute, 'second': second};

  @override
  bool operator ==(Object other) =>
      other is TimeComponents &&
      other.hour == hour &&
      other.minute == minute &&
      other.second == second;

  @override
  int get hashCode => Object.hash(hour, minute, second);

  @override
  String toString() => 'TimeComponents${toMap()}';
}

/// Result of `age()` and `diff()`.
class DiffComponents {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const DiffComponents(this.years, this.months, this.days, this.hours,
      this.minutes, this.seconds);

  Map<String, int> toMap() => {
        'years': years,
        'months': months,
        'days': days,
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds,
      };

  @override
  bool operator ==(Object other) =>
      other is DiffComponents &&
      other.years == years &&
      other.months == months &&
      other.days == days &&
      other.hours == hours &&
      other.minutes == minutes &&
      other.seconds == seconds;

  @override
  int get hashCode => Object.hash(years, months, days, hours, minutes, seconds);

  @override
  String toString() => 'DiffComponents${toMap()}';
}
