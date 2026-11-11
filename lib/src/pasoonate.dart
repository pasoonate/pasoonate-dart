import 'calendar_manager.dart';
import 'constants.dart';
import 'formatter/date_format.dart';
import 'formatter/simple_date_format.dart';
import 'lang/fa.dart';
import 'localization.dart';
import 'parser/parser.dart';
import 'parser/simple_parser.dart';

/// Entry point, e.g. `Pasoonate.make().jalali().format('yyyy/MM/dd')`.
abstract final class Pasoonate {
  static final Localization localization = Localization()..setLang('fa', fa);
  static DateFormat _formatter = SimpleDateFormat();
  static Parser _parser = SimpleParser();

  static DateFormat get formatter => _formatter;
  static Parser get parser => _parser;

  /// [timestamp] is Unix time in seconds, [timezoneOffset] in seconds.
  /// Both default to the current time and the device's timezone.
  static CalendarManager make([int? timestamp, int? timezoneOffset]) =>
      CalendarManager(timestamp, timezoneOffset);

  static dynamic trans(String key, [String? locale]) =>
      localization.trans(key, locale);

  static void setLocale(String locale) => localization.setLocale(locale);

  static String getLocale() => localization.getLocale();

  static bool isLocale(String locale) => localization.isLocale(locale);

  /// Pass `null` to restore the default [SimpleDateFormat].
  static void setFormatter(DateFormat? formatter) {
    _formatter = formatter ?? SimpleDateFormat();
  }

  /// Pass `null` to restore the default [SimpleParser].
  static void setParser(Parser? parser) {
    _parser = parser ?? SimpleParser();
  }

  static CalendarManager clone(CalendarManager instance) =>
      make(instance.getTimestamp(), instance.getTimezoneOffset());

  // Constants (also available on [Constants]).
  static const double J1970 = Constants.J1970;
  static const int Saturday = Constants.Saturday;
  static const int Sunday = Constants.Sunday;
  static const int Monday = Constants.Monday;
  static const int Tuesday = Constants.Tuesday;
  static const int Wednesday = Constants.Wednesday;
  static const int Thursday = Constants.Thursday;
  static const int Friday = Constants.Friday;
  static const int YearsPerCentury = Constants.YearsPerCentury;
  static const int YearsPerDecade = Constants.YearsPerDecade;
  static const int MonthsPerYear = Constants.MonthsPerYear;
  static const int WeeksPerYear = Constants.WeeksPerYear;
  static const int DaysPerWeek = Constants.DaysPerWeek;
  static const int HoursPerDay = Constants.HoursPerDay;
  static const int MinutesPerHour = Constants.MinutesPerHour;
  static const int SecondsPerMinute = Constants.SecondsPerMinute;
  static const int HourInSeconds = Constants.HourInSeconds;
  static const int DayInSeconds = Constants.DayInSeconds;
  static const int WeekInSeconds = Constants.WeekInSeconds;
  static const int MonthInSeconds = Constants.MonthInSeconds;
  static const int YearInSeconds = Constants.YearInSeconds;
  static const double MonthInDays = Constants.MonthInDays;
  static const double YearInDays = Constants.YearInDays;
  static const double ShiaEpoch = Constants.ShiaEpoch;
  static const double JalaliEpoch = Constants.JalaliEpoch;
  static const double GregorianEpoch = Constants.GregorianEpoch;
  static const double IslamicEpoch = Constants.IslamicEpoch;
  static const int DaysOfIslamicYear = Constants.DaysOfIslamicYear;
  static const int DaysOfShiaYear = Constants.DaysOfShiaYear;
  static const int DaysOfJalaliYear = Constants.DaysOfJalaliYear;
  static const double DaysOfTropicalJalaliYear =
      Constants.DaysOfTropicalJalaliYear;
  static const int DaysOfGregorianYear = Constants.DaysOfGregorianYear;
  static const String Gregorian = Constants.Gregorian;
  static const String Jalali = Constants.Jalali;
  static const String Shia = Constants.Shia;
  static const String Islamic = Constants.Islamic;
}
