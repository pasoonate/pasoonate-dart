part of '../calendar_manager.dart';

mixin Base on CalendarManagerCore {
  CalendarManager setTimestamp(int timestamp) {
    _timestamp = timestamp;
    return _self;
  }

  int getTimestamp() => _timestamp;

  /// Offset in seconds.
  CalendarManager setTimezoneOffset(int timezoneOffset) {
    _timezoneOffset = timezoneOffset;
    return _self;
  }

  int getTimezoneOffset() => _timezoneOffset;

  CalendarManager setYear(int year) {
    final d = _localDate();
    return _setLocal(year, d.month, d.day, d.hour, d.minute, d.second);
  }

  int getYear() => _localDate().year;

  CalendarManager setMonth(int month) {
    final d = _localDate();
    return _setLocal(d.year, month, d.day, d.hour, d.minute, d.second);
  }

  int getMonth() => _localDate().month;

  CalendarManager setDay(int day) {
    final d = _localDate();
    return _setLocal(d.year, d.month, day, d.hour, d.minute, d.second);
  }

  int getDay() => _localDate().day;

  CalendarManager setHour(int hour) {
    final d = _localDate();
    return _setLocal(d.year, d.month, d.day, hour, d.minute, d.second);
  }

  int getHour() => _localDate().hour;

  CalendarManager setMinute(int minute) {
    final d = _localDate();
    return _setLocal(d.year, d.month, d.day, d.hour, minute, d.second);
  }

  int getMinute() => _localDate().minute;

  CalendarManager setSecond(int second) {
    final d = _localDate();
    return _setLocal(d.year, d.month, d.day, d.hour, d.minute, second);
  }

  int getSecond() => _localDate().second;

  CalendarManager setUTCYear(int year) {
    final d = _utcDate();
    return _setUtc(year, d.month, d.day, d.hour, d.minute, d.second);
  }

  int getUTCYear() => _utcDate().year;

  CalendarManager setUTCMonth(int month) {
    final d = _utcDate();
    return _setUtc(d.year, month, d.day, d.hour, d.minute, d.second);
  }

  int getUTCMonth() => _utcDate().month;

  CalendarManager setUTCDay(int day) {
    final d = _utcDate();
    return _setUtc(d.year, d.month, day, d.hour, d.minute, d.second);
  }

  int getUTCDay() => _utcDate().day;

  CalendarManager setUTCHour(int hour) {
    final d = _utcDate();
    return _setUtc(d.year, d.month, d.day, hour, d.minute, d.second);
  }

  int getUTCHour() => _utcDate().hour;

  CalendarManager setUTCMinute(int minute) {
    final d = _utcDate();
    return _setUtc(d.year, d.month, d.day, d.hour, minute, d.second);
  }

  int getUTCMinute() => _utcDate().minute;

  CalendarManager setUTCSecond(int second) {
    final d = _utcDate();
    return _setUtc(d.year, d.month, d.day, d.hour, d.minute, second);
  }

  int getUTCSecond() => _utcDate().second;

  CalendarManager setDate(int year, int month, int day) {
    final d = _localDate();
    return _setLocal(year, month, day, d.hour, d.minute, d.second);
  }

  DateComponents getDate() {
    final d = _localDate();
    return DateComponents(d.year, d.month, d.day);
  }

  CalendarManager setTime(int hour, int minute, int second) {
    final d = _localDate();
    return _setLocal(d.year, d.month, d.day, hour, minute, second);
  }

  TimeComponents getTime() {
    final d = _localDate();
    return TimeComponents(d.hour, d.minute, d.second);
  }

  CalendarManager setDateTime(
          int year, int month, int day, int hour, int minute, int second) =>
      _setLocal(year, month, day, hour, minute, second);

  DateTimeComponents getDateTime() => _localDate();

  CalendarManager setUTCDate(int year, int month, int day) {
    final d = _utcDate();
    return _setUtc(year, month, day, d.hour, d.minute, d.second);
  }

  DateComponents getUTCDate() {
    final d = _utcDate();
    return DateComponents(d.year, d.month, d.day);
  }

  CalendarManager setUTCTime(int hour, int minute, int second) {
    final d = _utcDate();
    return _setUtc(d.year, d.month, d.day, hour, minute, second);
  }

  TimeComponents getUTCTime() {
    final d = _utcDate();
    return TimeComponents(d.hour, d.minute, d.second);
  }

  CalendarManager setUTCDateTime(
          int year, int month, int day, int hour, int minute, int second) =>
      _setUtc(year, month, day, hour, minute, second);

  DateTimeComponents getUTCDateTime() => _utcDate();

  /// From 0 (Saturday) to 6 (Friday).
  int dayOfWeek() => _currentCalendar.dayOfWeek(_timestamp + _timezoneOffset);

  int dayOfYear() => _currentCalendar.dayOfYear(_timestamp + _timezoneOffset);

  int weekOfMonth() =>
      _currentCalendar.weekOfMonth(_timestamp + _timezoneOffset);

  int weekOfYear() => _currentCalendar.weekOfYear(_timestamp + _timezoneOffset);
}
