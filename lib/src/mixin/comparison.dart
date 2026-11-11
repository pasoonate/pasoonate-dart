part of '../calendar_manager.dart';

mixin Comparison on CalendarManagerCore {
  bool equal(CalendarManager other) => _timestamp == other._timestamp;

  bool afterThan(CalendarManager other) => _timestamp > other._timestamp;

  bool afterThanOrEqual(CalendarManager other) =>
      _timestamp >= other._timestamp;

  bool beforeThan(CalendarManager other) => _timestamp < other._timestamp;

  bool beforeThanOrEqual(CalendarManager other) =>
      _timestamp <= other._timestamp;

  bool between(CalendarManager value1, CalendarManager value2) =>
      value1._timestamp <= _timestamp && value2._timestamp >= _timestamp;

  CalendarManager min(CalendarManager other) =>
      _timestamp <= other._timestamp ? _self : other;

  CalendarManager max(CalendarManager other) =>
      _timestamp >= other._timestamp ? _self : other;

  int get _dow => _currentCalendar.dayOfWeek(_timestamp + _timezoneOffset);

  bool isWeekday() => _dow != Constants.Friday;

  bool isWeekend() => _dow == Constants.Friday;

  bool isSaturday() => _dow == Constants.Saturday;

  bool isSunday() => _dow == Constants.Sunday;

  bool isMonday() => _dow == Constants.Monday;

  bool isTuesday() => _dow == Constants.Tuesday;

  bool isWednesday() => _dow == Constants.Wednesday;

  bool isThursday() => _dow == Constants.Thursday;

  bool isFriday() => _dow == Constants.Friday;

  bool isYesterday() {
    final yesterday = Pasoonate.make().gregorian().subDay(1);
    return _self.gregorian().diffInDays(yesterday) == 0;
  }

  bool isToday() {
    final today = Pasoonate.make().gregorian();
    return _self.gregorian().diffInDays(today) == 0;
  }

  bool isTomorrow() {
    final tomorrow = Pasoonate.make().gregorian().addDay(1);
    return _self.gregorian().diffInDays(tomorrow) == 0;
  }

  bool isFuture() {
    final today = Pasoonate.make().gregorian();
    return _self.gregorian().diffInDays(today) > 1;
  }

  bool isPast() {
    final today = Pasoonate.make().gregorian();
    return today.gregorian().diffInDays(_self) > 1;
  }

  bool isLeapYear() => _currentCalendar.isLeap(_self.getYear());

  bool isSameDay(CalendarManager other) =>
      _self.gregorian().diffInDays(other) == 0;
}
