import '../components.dart';
import '../constants.dart';
import 'calendar.dart';

class IslamicCalendar extends Calendar {
  final double IslamicEpoch = Constants.IslamicEpoch;

  @override
  String get name => Constants.Islamic;

  @override
  double dateToJulianDay(
      int year, int month, int day, int hour, int minute, int second) {
    double julianDay = day.toDouble();

    julianDay += ((month - 1) * 29.5).ceil();
    julianDay += (year - 1) * 354;
    julianDay += (((11 * year) + 3) / 30).floor();
    julianDay += IslamicEpoch - 1;

    return addTimeToJulianDay(julianDay, hour, minute, second);
  }

  @override
  DateTimeComponents julianDayToDate(double julianDay) {
    final time = extractJulianDayTime(julianDay);
    final h = time.hour, mi = time.minute, s = time.second;

    julianDay = julianDayWithoutTime(julianDay);
    julianDay = julianDay.floorToDouble() + 0.5;

    final year = ((((julianDay - IslamicEpoch) * 30) + 10646) / 10631).floor();
    var month = ((julianDay -
                    (29 +
                        julianDayWithoutTime(
                            dateToJulianDay(year, 1, 1, h, mi, s)))) /
                29.5)
            .ceil() +
        1;
    if (month > 12) month = 12;
    final day = (julianDay -
                julianDayWithoutTime(dateToJulianDay(year, month, 1, h, mi, s)))
            .round() +
        1;

    return DateTimeComponents(year, month, day, h, mi, s);
  }

  @override
  int daysInMonth(int year, int month) {
    const days = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
    checkMonth(month);

    if (year != 0 && isLeap(year) && month == 12) {
      return 30;
    }

    return days[month - 1];
  }

  @override
  bool isLeap(int year) => ((year * 11) + 14).remainder(30) < 11;
}
