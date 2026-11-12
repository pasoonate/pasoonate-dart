part of '../calendar_manager.dart';

mixin AdditionAndSubtraction on CalendarManagerCore {
  CalendarManager _withClampedDay(DateTimeComponents d, int year, int month) {
    final dim = _currentCalendar.daysInMonth(year, month);
    final day = d.day <= dim ? d.day : dim;
    return _setLocal(year, month, day, d.hour, d.minute, d.second);
  }

  CalendarManager addYear(int count) {
    final d = _localDate();
    return _withClampedDay(d, d.year + count, d.month);
  }

  CalendarManager addMonth(int count) {
    final d = _localDate();
    final totalMonth = d.month + count;
    final year = d.year + ((totalMonth / 12) - 1).ceil();
    final rest = totalMonth.remainder(12);
    final month = rest == 0 ? 12 : rest;
    return _withClampedDay(d, year, month);
  }

  CalendarManager addDay(int count) {
    _timestamp += count * 86400;
    return _self;
  }

  CalendarManager addHour(int count) {
    _timestamp += count * 3600;
    return _self;
  }

  CalendarManager addMinute(int count) {
    _timestamp += count * 60;
    return _self;
  }

  CalendarManager addSecond(int count) {
    _timestamp += count;
    return _self;
  }

  CalendarManager subYear(int count) {
    final d = _localDate();
    return _withClampedDay(d, d.year - count, d.month);
  }

  CalendarManager subMonth(int count) {
    final d = _localDate();
    var totalMonth = d.month - count;
    var year = d.year;
    var month = totalMonth;

    if (totalMonth <= 0) {
      totalMonth = -totalMonth;
      year -= (totalMonth ~/ 12) + 1;
      month = 12 - totalMonth.remainder(12);
    }

    return _withClampedDay(d, year, month);
  }

  CalendarManager subDay(int count) {
    _timestamp -= count * 86400;
    return _self;
  }

  CalendarManager subHour(int count) {
    _timestamp -= count * 3600;
    return _self;
  }

  CalendarManager subMinute(int count) {
    _timestamp -= count * 60;
    return _self;
  }

  CalendarManager subSecond(int count) {
    _timestamp -= count;
    return _self;
  }
}
