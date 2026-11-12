import 'calendar/calendar.dart';
import 'calendar/gregorian_calendar.dart';
import 'calendar/islamic_calendar.dart';
import 'calendar/jalali_calendar.dart';
import 'calendar/shia_calendar.dart';
import 'components.dart';
import 'constants.dart';
import 'pasoonate.dart';

part 'mixin/base.dart';
part 'mixin/addition_and_subtraction.dart';
part 'mixin/difference.dart';
part 'mixin/comparison.dart';
part 'mixin/modifiers.dart';

/// Shared state used by the mixins.
abstract class CalendarManagerCore {
  final GregorianCalendar _gregorian = GregorianCalendar();
  final JalaliCalendar _jalali = JalaliCalendar();
  final IslamicCalendar _islamic = IslamicCalendar();
  final ShiaCalendar _shia = ShiaCalendar();
  Calendar? _currentCalendarOrNull;
  int _timestamp;
  int _timezoneOffset;

  CalendarManagerCore(int? timestamp, int? timezoneOffset)
      : _timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        _timezoneOffset =
            timezoneOffset ?? DateTime.now().timeZoneOffset.inSeconds;

  /// The selected calendar. Throws a [StateError] if none was selected yet
  /// (call `gregorian()`, `jalali()`, `islamic()` or `shia()` first).
  Calendar get _currentCalendar =>
      _currentCalendarOrNull ??
      (throw StateError(
          'No calendar selected. Call gregorian(), jalali(), islamic() or shia() first.'));

  CalendarManager get _self => this as CalendarManager;

  DateTimeComponents _localDate() =>
      _currentCalendar.timestampToDate(_timestamp + _timezoneOffset);

  DateTimeComponents _utcDate() => _currentCalendar.timestampToDate(_timestamp);

  CalendarManager _setLocal(
      int year, int month, int day, int hour, int minute, int second) {
    _timestamp = _currentCalendar.dateToTimestamp(
            year, month, day, hour, minute, second) -
        _timezoneOffset;
    return _self;
  }

  CalendarManager _setUtc(
      int year, int month, int day, int hour, int minute, int second) {
    _timestamp = _currentCalendar.dateToTimestamp(
        year, month, day, hour, minute, second);
    return _self;
  }
}

class CalendarManager extends CalendarManagerCore
    with Base, AdditionAndSubtraction, Difference, Comparison, Modifiers {
  /// [timestamp] in Unix seconds, [timezoneOffset] in seconds.
  CalendarManager([super.timestamp, super.timezoneOffset]);

  CalendarManager _select(Calendar calendar, String? dateTime) {
    _currentCalendarOrNull = calendar;

    if (dateTime != null && dateTime.isNotEmpty) {
      parse('yyyy-MM-dd HH:mm:ss', dateTime);
    }

    return this;
  }

  CalendarManager gregorian([String? dateTime]) =>
      _select(_gregorian, dateTime);

  CalendarManager jalali([String? dateTime]) => _select(_jalali, dateTime);

  CalendarManager islamic([String? dateTime]) => _select(_islamic, dateTime);

  CalendarManager shia([String? dateTime]) => _select(_shia, dateTime);

  /// Without an argument returns the current calendar name (or `''`).
  /// With an argument switches to that calendar (if it exists).
  String name([String? calendar]) {
    if (calendar != null && calendar.isNotEmpty) {
      final instance = switch (calendar.toLowerCase()) {
        Constants.Gregorian => _gregorian,
        Constants.Jalali => _jalali,
        Constants.Islamic => _islamic,
        Constants.Shia => _shia,
        _ => null,
      };

      if (instance != null) {
        _currentCalendarOrNull = instance;
      }
    }

    return _currentCalendarOrNull?.getName() ?? '';
  }

  /// The selected calendar instance, or `null`.
  Calendar? get currentCalendar => _currentCalendarOrNull;

  CalendarManager parse(String pattern, String text) {
    final parser = Pasoonate.parser;
    parser.calendar = this;
    parser.parse(pattern, text);

    return this;
  }

  String format([String? pattern, String? locale]) {
    final formatter = Pasoonate.formatter;
    formatter.setCalendar(this);

    return formatter.format(pattern, locale);
  }

  CalendarManager clone() =>
      Pasoonate.make(getTimestamp(), getTimezoneOffset());
}
