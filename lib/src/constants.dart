/// Constants shared by the calendars (same names as the JS package).
abstract final class Constants {
  static const double J1970 =
      2440587.5; // Julian date at Unix epoch: 1970-01-01
  static const int Saturday = 0;
  static const int Sunday = 1;
  static const int Monday = 2;
  static const int Tuesday = 3;
  static const int Wednesday = 4;
  static const int Thursday = 5;
  static const int Friday = 6;
  static const int YearsPerCentury = 100;
  static const int YearsPerDecade = 10;
  static const int MonthsPerYear = 12;
  static const int WeeksPerYear = 52;
  static const int DaysPerWeek = 7;
  static const int HoursPerDay = 24;
  static const int MinutesPerHour = 60;
  static const int SecondsPerMinute = 60;
  static const int HourInSeconds = 3600;
  static const int DayInSeconds = 86400;
  static const int WeekInSeconds = 604800;
  static const int MonthInSeconds = 2629743;
  static const int YearInSeconds = 31556926;
  static const double MonthInDays = 30.44;
  static const double YearInDays = 365.24;
  static const double ShiaEpoch = 1948439.5;
  static const double JalaliEpoch = 1948320.5;
  static const double GregorianEpoch = 1721425.5;
  static const double IslamicEpoch = 1948439.5;
  static const int DaysOfIslamicYear = 354;
  static const int DaysOfShiaYear = 354;
  static const int DaysOfJalaliYear = 365;
  static const double DaysOfTropicalJalaliYear = 365.24219878;
  static const int DaysOfGregorianYear = 365;
  static const String Gregorian = 'gregorian';
  static const String Jalali = 'jalali';
  static const String Shia = 'shia';
  static const String Islamic = 'islamic';
}
