import '../pasoonate.dart';
import 'date_format.dart';

/// Formats with tokens: yyyy yy MMMM MMM MM M dddd ddd dd d HH H mm m ss s.
/// Any other character is copied as-is.
class SimpleDateFormat extends DateFormat {
  static const FullYear = 'yyyy';
  static const ShortYear = 'yy';
  static const FullMonthName = 'MMMM';
  static const ShortMonthName = 'MMM';
  static const FullMonth = 'MM';
  static const ShortMonth = 'M';
  static const ShortDayName = 'ddd';
  static const FullDayName = 'dddd';
  static const FullDay = 'dd';
  static const ShortDay = 'd';
  static const FullHour = 'HH';
  static const ShortHour = 'H';
  static const FullMinute = 'mm';
  static const ShortMinute = 'm';
  static const FullSecond = 'ss';
  static const ShortSecond = 's';

  @override
  String format([String? pattern, String? locale]) =>
      compile(pattern ?? '', locale);

  String compile(String pattern, [String? locale]) {
    final c = getCalendar();
    if (c == null) {
      return '';
    }

    final categories = <String>[];
    var prevChar = '';

    for (final currChar in pattern.split('')) {
      if (currChar == prevChar && categories.isNotEmpty) {
        categories[categories.length - 1] += currChar;
      } else {
        categories.add(currChar);
      }

      prevChar = currChar;
    }

    String pad(int v) => v > 9 ? '$v' : '0$v';
    String trans(String key) =>
        '${Pasoonate.trans('${c.name()}.$key', locale)}';

    return categories.map((category) {
      switch (category) {
        case FullYear:
          return '${c.getYear()}';
        case ShortYear:
          final year = '${c.getYear()}';
          return year.length > 2 ? year.substring(year.length - 2) : year;
        case FullMonthName:
          return trans('month_name.${c.getMonth()}');
        case ShortMonthName:
          return trans('short_month_name.${c.getMonth()}');
        case FullMonth:
          return pad(c.getMonth());
        case ShortMonth:
          return '${c.getMonth()}';
        case FullDayName:
          return trans('day_name.${c.dayOfWeek()}');
        case ShortDayName:
          return trans('short_day_name.${c.dayOfWeek()}');
        case FullDay:
          return pad(c.getDay());
        case ShortDay:
          return '${c.getDay()}';
        case FullHour:
          return pad(c.getHour());
        case ShortHour:
          return '${c.getHour()}';
        case FullMinute:
          return pad(c.getMinute());
        case ShortMinute:
          return '${c.getMinute()}';
        case FullSecond:
          return pad(c.getSecond());
        case ShortSecond:
          return '${c.getSecond()}';
        default:
          return category;
      }
    }).join();
  }
}
