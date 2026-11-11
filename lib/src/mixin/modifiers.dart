part of '../calendar_manager.dart';

mixin Modifiers on CalendarManagerCore {
  CalendarManager startOfDay() => _self.setTime(0, 0, 0);

  CalendarManager endOfDay() => _self.setTime(23, 59, 59);

  CalendarManager startOfMonth() => _self.setDay(1).startOfDay();

  CalendarManager endOfMonth() => _self
      .setDay(_currentCalendar.daysInMonth(_self.getYear(), _self.getMonth()))
      .endOfDay();

  CalendarManager startOfYear() => _self.setMonth(1).startOfMonth();

  CalendarManager endOfYear() => _self.setMonth(12).endOfMonth();

  CalendarManager startOfWeek() => _self.subDay(_self.dayOfWeek()).startOfDay();

  CalendarManager endOfWeek() => _self.addDay(6 - _self.dayOfWeek()).endOfDay();
}
