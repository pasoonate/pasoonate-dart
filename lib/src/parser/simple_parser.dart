import '../calendar_manager.dart';
import '../pasoonate.dart';
import 'parser.dart';

/// Parses text using the same tokens as `SimpleDateFormat`.
class SimpleParser extends Parser {
  static const FULL_YEAR = 'yyyy';
  static const SHORT_YEAR = 'yy';
  static const FULL_MONTH_NAME = 'MMMM';
  static const SHORT_MONTH_NAME = 'MMM';
  static const FULL_MONTH = 'MM';
  static const SHORT_MONTH = 'M';
  static const SHORT_DAY_NAME = 'ddd';
  static const FULL_DAY_NAME = 'dddd';
  static const FULL_DAY = 'dd';
  static const SHORT_DAY = 'd';
  static const FULL_HOUR = 'HH';
  static const SHORT_HOUR = 'H';
  static const FULL_MINUTE = 'mm';
  static const SHORT_MINUTE = 'm';
  static const FULL_SECOND = 'ss';
  static const SHORT_SECOND = 's';

  static const Map<String, String> patterns = {
    FULL_YEAR: r'(\d{4})',
    SHORT_YEAR: r'(\d{2})',
    FULL_MONTH_NAME: r'(\D+)',
    SHORT_MONTH_NAME: r'(\D+)',
    FULL_MONTH: r'(\d{2})',
    SHORT_MONTH: r'(\d{1,2})',
    FULL_DAY_NAME: r'(\D+)',
    SHORT_DAY_NAME: r'(\D+)',
    FULL_DAY: r'(\d{2})',
    SHORT_DAY: r'(\d{1,2})',
    FULL_HOUR: r'(\d{2})',
    SHORT_HOUR: r'(\d{1,2})',
    FULL_MINUTE: r'(\d{2})',
    SHORT_MINUTE: r'(\d{1,2})',
    FULL_SECOND: r'(\d{2})',
    SHORT_SECOND: r'(\d{1,2})',
  };

  /// Translates the [format] to a regular expression and the token sequence.
  ({String pattern, List<String> sequence}) translate(String format) {
    final categories = <String>[];
    final sequence = <String>[];
    var prevChar = '';

    for (final currChar in format.split('')) {
      if (currChar == prevChar && categories.isNotEmpty) {
        categories[categories.length - 1] += currChar;
      } else {
        categories.add(currChar);
      }

      prevChar = currChar;
    }

    for (var i = 0; i < categories.length; i++) {
      final regex = patterns[categories[i]];
      if (regex != null) {
        sequence.add(categories[i]);
        categories[i] = regex;
      }
    }

    return (pattern: categories.join(), sequence: sequence);
  }

  Map<String, String> match(
      String pattern, String text, List<String> sequence) {
    final m = RegExp(pattern).firstMatch(text);
    if (m == null) {
      return {};
    }

    return {
      for (var i = 1; i <= m.groupCount && i <= sequence.length; i++)
        if (m.group(i) != null) sequence[i - 1]: m.group(i)!,
    };
  }

  /// Returns the month number whose translated name equals [value], or null.
  int? _monthFromName(CalendarManager calendar, String key, String value) {
    final names = Pasoonate.trans('${calendar.name()}.$key');
    if (names is Map) {
      for (final entry in names.entries) {
        if (entry.value == value) return int.tryParse('${entry.key}');
      }
    } else if (names is List) {
      final index = names.indexOf(value);
      if (index >= 0) return index + 1;
    }
    return null;
  }

  @override
  void parse(String format, String text) {
    final calendar = this.calendar;
    if (calendar == null) {
      throw StateError('SimpleParser.calendar is not set.');
    }

    final result = translate(format);
    final components = match(result.pattern, text, result.sequence);
    final dateTime = calendar.getDateTime();

    components.forEach((key, value) {
      switch (key) {
        case FULL_YEAR:
          dateTime.year = int.parse(value);
        case SHORT_YEAR:
          final now = CalendarManager();
          now.name(calendar.name());
          dateTime.year = (now.getYear() ~/ 100) * 100 + int.parse(value);
        case FULL_MONTH:
        case SHORT_MONTH:
          dateTime.month = int.parse(value);
        case FULL_DAY:
        case SHORT_DAY:
          dateTime.day = int.parse(value);
        case FULL_HOUR:
        case SHORT_HOUR:
          dateTime.hour = int.parse(value);
        case FULL_MINUTE:
        case SHORT_MINUTE:
          dateTime.minute = int.parse(value);
        case FULL_SECOND:
        case SHORT_SECOND:
          dateTime.second = int.parse(value);
        case FULL_MONTH_NAME:
          final month = _monthFromName(calendar, 'month_name', value);
          if (month != null) dateTime.month = month;
        case SHORT_MONTH_NAME:
          final month = _monthFromName(calendar, 'short_month_name', value);
          if (month != null) dateTime.month = month;
        case FULL_DAY_NAME:
        case SHORT_DAY_NAME:
          // Day names do not change the date (same as the JS package).
          break;
      }
    });

    calendar.setDateTime(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute, dateTime.second);
  }
}
