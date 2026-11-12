import '../components.dart';
import '../constants.dart';
import 'calendar.dart';

class JalaliCalendar extends Calendar {
  final double JalaliEpoch = Constants.JalaliEpoch;

  @override
  String get name => Constants.Jalali;

  @override
  double dateToJulianDay(
      int year, int month, int day, int hour, int minute, int second) {
    var timestamp = 0;
    var days = 0;

    days += ((year - 1) * Constants.DaysOfTropicalJalaliYear).floor();
    days += month <= 7 ? ((month - 1) * 31) : (((month - 1) * 30) + 6);
    days += day - 1;

    if (isLeap(year - 1)) {
      days++;
    }

    timestamp += days * Constants.DayInSeconds;
    timestamp += (hour * Constants.HourInSeconds) +
        (minute * Constants.SecondsPerMinute) +
        second;
    timestamp -= 42531868800;

    return timestampToJulianDay(timestamp);
  }

  @override
  DateTimeComponents julianDayToDate(double julianDay) {
    final timestamp = julianDayToTimestamp(julianDay);
    final base = timestamp + 42531868800;
    final second = mod(base, Constants.SecondsPerMinute).toInt();
    final minute =
        (mod(base, Constants.HourInSeconds) / Constants.SecondsPerMinute)
            .floor();
    final hour =
        (mod(base, Constants.DayInSeconds) / Constants.HourInSeconds).floor();
    final days = (base / Constants.DayInSeconds).floor();
    final fyear = (days / Constants.DaysOfTropicalJalaliYear).floor();
    var year = (days / Constants.DaysOfJalaliYear).floor();
    var dayOfYear = days - (fyear * Constants.DaysOfTropicalJalaliYear).floor();

    if (isLeap(fyear)) {
      dayOfYear--;
    }

    if (dayOfYear >= Constants.DaysOfJalaliYear && !isLeap(year)) {
      dayOfYear = 0;
      year++;
    }

    if (year == fyear) {
      year++;
    }

    final month =
        (dayOfYear <= 186 ? (dayOfYear / 31) : ((dayOfYear - 6) / 30)).floor() +
            1;
    final day = dayOfYear -
        (month <= 7 ? (month - 1) * 31 : ((month - 1) * 30) + 6) +
        1;

    return DateTimeComponents(year, month, day, hour, minute, second);
  }

  @override
  int daysInMonth(int year, int month) {
    const days = [31, 31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 29];
    checkMonth(month);

    if (year != 0 && isLeap(year) && month == Constants.MonthsPerYear) {
      return 30;
    }

    return days[month - 1];
  }

  @override
  bool isLeap(int year) {
    const after1343 = [1, 5, 9, 13, 17, 22, 26, 30];
    const before1343 = [1, 5, 9, 13, 17, 21, 26, 30];

    final remain = year.remainder(33);

    return year < 1343
        ? before1343.contains(remain)
        : after1343.contains(remain);
  }
}
