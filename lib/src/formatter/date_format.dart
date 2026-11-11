import '../calendar_manager.dart';

/// Base formatter. Extend it and register with `Pasoonate.setFormatter()`.
class DateFormat {
  CalendarManager? _calendar;

  void setCalendar(CalendarManager? calendar) {
    _calendar = calendar;
  }

  CalendarManager? getCalendar() => _calendar;

  String format([String? pattern, String? locale]) {
    final c = _calendar;
    if (c == null) {
      return '';
    }

    return '${c.getYear()}-${c.getMonth()}-${c.getDay()} '
        '${c.getHour()}:${c.getMinute()}:${c.getSecond()}';
  }
}
