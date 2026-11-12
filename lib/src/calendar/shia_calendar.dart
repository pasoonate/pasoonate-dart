import '../components.dart';
import '../constants.dart';
import 'calendar.dart';

class ShiaCalendar extends Calendar {
  final double ShiaEpoch = Constants.ShiaEpoch;

  static const Map<int, List<int>> daysInMonthInYears = {
    1435: [29, 30, 29, 30, 29, 30, 29, 30, 30, 30, 29, 30],
    1436: [29, 30, 29, 29, 30, 29, 30, 29, 30, 29, 30, 30],
    1437: [29, 30, 30, 29, 30, 29, 29, 30, 29, 29, 30, 30],
    1438: [29, 30, 30, 30, 29, 30, 29, 29, 30, 29, 29, 30],
    1439: [29, 30, 30, 30, 30, 29, 30, 29, 29, 30, 29, 29],
    1440: [30, 29, 30, 30, 30, 29, 30, 29, 30, 29, 30, 29],
    1441: [29, 30, 29, 30, 30, 29, 30, 30, 29, 30, 29, 30],
    1442: [29, 29, 30, 29, 30, 29, 30, 30, 29, 30, 30, 29],
    1443: [29, 30, 30, 29, 29, 30, 29, 29, 30, 29, 30, 30],
    1444: [30, 30, 29, 30, 29, 29, 30, 29, 30, 29, 30, 29],
    1445: [30, 30, 30, 29, 30, 29, 29, 30, 29, 30, 29, 29],
    1446: [30, 30, 30, 29, 30, 30, 29, 30, 29, 29, 29, 30],
    1447: [29, 30, 30, 29, 30, 30, 30, 29, 30, 29, 29, 29],
    1448: [30, 29, 30, 29, 30, 30, 30, 29, 30, 30, 29, 30],
  };

  static const Map<int, double> julianDaysFirstOfYear = {
    1435: 2456601.5,
    1436: 2456956.5,
    1437: 2457310.5,
    1438: 2457664.5,
    1439: 2458018.5,
    1440: 2458372.5,
    1441: 2458727.5,
    1442: 2459082.5,
    1443: 2459436.5,
    1444: 2459790.5,
    1445: 2460144.5,
    1446: 2460498.5,
    1447: 2460853.5,
  };

  @override
  String get name => Constants.Shia;

  @override
  double dateToJulianDay(
      int year, int month, int day, int hour, int minute, int second) {
    final dim = daysInMonth(year, month);
    var dayOfYear = day;
    final firstOfYear = julianDayFirstOfYear(year);
    double julianDay = 0;

    if (day > dim) {
      dayOfYear = day - dim;
      year = month == 12 ? year + 1 : year;
      month = month == 12 ? 1 : month + 1;
    }

    for (var m = 1; m < month; m++) {
      dayOfYear += daysInMonth(year, m);
    }

    julianDay += dayOfYear;

    if (firstOfYear != 0) {
      julianDay += firstOfYear - 1;
    } else {
      julianDay += (year - 1) * Constants.DaysOfShiaYear;
      julianDay += (((11 * year) + 14) / 30).floor();
      julianDay += ShiaEpoch - (year == 1440 ? 2 : 1);
    }

    return addTimeToJulianDay(julianDay, hour, minute, second);
  }

  @override
  DateTimeComponents julianDayToDate(double julianDay) {
    final time = extractJulianDayTime(julianDay);
    final h = time.hour, mi = time.minute, s = time.second;

    julianDay = julianDayWithoutTime(julianDay);

    final year = ((((julianDay - ShiaEpoch) * 30) + 10646) / 10631).floor();
    var month = ((julianDay -
                    (29 +
                        julianDayWithoutTime(
                            dateToJulianDay(year, 1, 1, h, mi, s)))) /
                29.5)
            .ceil() +
        1;
    if (month > 12) month = 12;
    final dayOfYear =
        (julianDay - dateToJulianDay(year, 1, 1, 0, 0, 0)).round() + 1;
    var days = 0;

    for (var i = 1; i <= 12; i++) {
      days += daysInMonth(year, i);
      if (dayOfYear <= days) {
        month = i;
        break;
      }
    }

    final day = dayOfYear - (days - daysInMonth(year, month));

    return DateTimeComponents(year, month, day, h, mi, s);
  }

  @override
  int daysInMonth(int year, int month) {
    const islamicDays = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
    checkMonth(month);

    final days = daysInMonthInYears[year];
    if (days == null) {
      return islamicDays[month - 1];
    }

    return days[month - 1];
  }

  double julianDayFirstOfYear(int year) {
    final known = julianDaysFirstOfYear[year];
    if (known != null) {
      return known;
    }

    final years = julianDaysFirstOfYear.keys;
    final minYear = years.reduce((a, b) => a < b ? a : b);
    final maxYear = years.reduce((a, b) => a > b ? a : b);

    if (year > maxYear) {
      return julianDaysFirstOfYear[maxYear]! +
          ((year - maxYear) * Constants.DaysOfShiaYear);
    }

    return julianDaysFirstOfYear[minYear]! -
        ((minYear - year) * Constants.DaysOfShiaYear);
  }

  @override
  bool isLeap(int year) => ((year * 11) + 14).remainder(30) < 11;
}
