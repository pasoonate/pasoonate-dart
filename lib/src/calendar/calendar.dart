import '../components.dart';
import '../constants.dart';

/// JavaScript `Math.round` (rounds .5 toward +infinity).
int jsRound(num x) => (x + 0.5).floor();

/// Base class of all calendars. Julian days are `double`, timestamps are
/// Unix seconds (`int`).
abstract class Calendar {
  final double J1970 = Constants.J1970;

  String get name;

  String getName() => name;

  double timestampToJulianDay(int timestamp) {
    final julianDay = timestamp / Constants.DayInSeconds + J1970;
    final floor = julianDay.floorToDouble();
    final fraction = jsRound((julianDay - floor) * 10000000) / 10000000;

    return floor + fraction;
  }

  int julianDayToTimestamp(double julianDay) =>
      jsRound((julianDay - J1970) * Constants.DayInSeconds);

  double julianDayWithoutTime(double julianDay) {
    final floor = julianDay.floorToDouble();
    return floor + ((julianDay - floor) >= 0.5 ? 0.5 : -0.5);
  }

  TimeComponents extractJulianDayTime(double julianDay) {
    julianDay += 0.5;

    // Astronomical to civil
    final time = jsRound(
        (julianDay - julianDay.truncateToDouble()) * Constants.DayInSeconds);

    return TimeComponents(
      time ~/ 3600,
      (time ~/ 60).remainder(60),
      time.remainder(60),
    );
  }

  double addTimeToJulianDay(
      double julianDay, int hour, int minute, int second) {
    var timestamp = julianDayToTimestamp(julianDay);
    timestamp += (hour * 3600) + (minute * 60) + second;

    julianDay = timestampToJulianDay(timestamp);
    final floor = julianDay.floorToDouble();
    final fraction = jsRound((julianDay - floor) * 10000000) / 10000000;

    return floor + fraction;
  }

  double dateToJulianDay(
      int year, int month, int day, int hour, int minute, int second);

  int dateToTimestamp(
          int year, int month, int day, int hour, int minute, int second) =>
      julianDayToTimestamp(
          dateToJulianDay(year, month, day, hour, minute, second));

  DateTimeComponents julianDayToDate(double julianDay);

  DateTimeComponents timestampToDate(int timestamp) =>
      julianDayToDate(timestampToJulianDay(timestamp));

  int daysInMonth(int year, int month);

  /// From 0 (Saturday) to 6 (Friday).
  int dayOfWeek(int timestamp) {
    final julianDay = timestampToJulianDay(timestamp);
    return mod((julianDay + 2.5).floor(), 7).toInt();
  }

  int dayOfYear(int timestamp) {
    final d = timestampToDate(timestamp);
    final firstOfYear = dateToJulianDay(d.year, 1, 1, 0, 0, 0);
    final current =
        dateToJulianDay(d.year, d.month, d.day, d.hour, d.minute, d.second);

    return (current - firstOfYear + 1).floor();
  }

  /// Unlike the JS package (which can return a fraction in rare cases),
  /// the result is always a whole number (floored).
  int weekOfMonth(int timestamp) {
    final d = timestampToDate(timestamp);
    final firstDayOfMonth =
        dateToTimestamp(d.year, d.month, 1, d.hour, d.minute, d.second);
    final dayOfWeekCurrent = dayOfWeek(timestamp);
    final dayOfWeekFirst = dayOfWeek(firstDayOfMonth);

    if (d.day <= 7 - dayOfWeekFirst) {
      return 1;
    }

    return 1 +
        ((d.day - ((7 - dayOfWeekFirst) + (dayOfWeekCurrent + 1))) / 7 + 1)
            .floor();
  }

  int weekOfYear(int timestamp) {
    final d = timestampToDate(timestamp);
    final doy = dayOfYear(timestamp);
    final firstDayOfYear =
        dateToTimestamp(d.year, 1, 1, d.hour, d.minute, d.second);
    final dayOfWeekCurrent = dayOfWeek(timestamp);
    final dayOfWeekFirst = dayOfWeek(firstDayOfYear);

    if (doy <= 7 - dayOfWeekFirst) {
      return 1;
    }

    return 1 +
        ((doy - ((7 - dayOfWeekFirst) + (dayOfWeekCurrent + 1))) / 7 + 1)
            .floor();
  }

  /// Floored modulo (`a - b * floor(a / b)`).
  num mod(num a, num b) => a - (b * (a / b).floor());

  bool isLeap(int year);

  void checkMonth(int month) {
    if (month < 1 || month > 12) {
      throw RangeError.range(month, 1, 12, 'month', 'Out Of Range');
    }
  }
}
