import '../components.dart';
import '../constants.dart';
import 'calendar.dart';

class GregorianCalendar extends Calendar {
  final double GregorianEpoch = Constants.GregorianEpoch;

  @override
  String get name => Constants.Gregorian;

  @override
  double dateToJulianDay(
      int year, int month, int day, int hour, int minute, int second) {
    var julianDay = GregorianEpoch - 1;

    julianDay += 365 * (year - 1);
    julianDay += ((year - 1) / 4).floor();
    julianDay += ((year - 1) / 100).floor() * -1;
    julianDay += ((year - 1) / 400).floor();
    julianDay += ((((367 * month) - 362) / 12) +
            ((month <= 2) ? 0 : (isLeap(year) ? -1 : -2)) +
            day)
        .floor();

    return addTimeToJulianDay(julianDay, hour, minute, second);
  }

  @override
  DateTimeComponents julianDayToDate(double julianDay) {
    final time = extractJulianDayTime(julianDay);
    final h = time.hour, mi = time.minute, s = time.second;

    julianDay = julianDayWithoutTime(julianDay);

    final wjd = (julianDay - 0.5).floorToDouble() + 0.5;
    final depoch = wjd - GregorianEpoch;
    final quadricent = (depoch / 146097).floor();
    final dqc = mod(depoch, 146097);
    final cent = (dqc / 36524).floor();
    final dcent = mod(dqc, 36524);
    final quad = (dcent / 1461).floor();
    final dquad = mod(dcent, 1461);
    final yindex = (dquad / 365).floor();
    var year = (quadricent * 400) + (cent * 100) + (quad * 4) + yindex;
    if (!(cent == 4 || yindex == 4)) {
      year++;
    }
    final yearday =
        wjd - julianDayWithoutTime(dateToJulianDay(year, 1, 1, h, mi, s));
    final leapadj =
        wjd < julianDayWithoutTime(dateToJulianDay(year, 3, 1, h, mi, s))
            ? 0
            : (isLeap(year) ? 1 : 2);
    final month = ((((yearday + leapadj) * 12) + 373) / 367).floor();
    final day =
        (wjd - julianDayWithoutTime(dateToJulianDay(year, month, 1, h, mi, s)))
                .round() +
            1;

    return DateTimeComponents(year, month, day, h, mi, s);
  }

  @override
  int daysInMonth(int year, int month) {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    checkMonth(month);

    if (year != 0 && isLeap(year) && month == 2) {
      return 29;
    }

    return days[month - 1];
  }

  @override
  bool isLeap(int year) =>
      year.remainder(4) == 0 &&
      (year.remainder(100) != 0 || year.remainder(400) == 0);
}
