part of '../calendar_manager.dart';

mixin Difference on CalendarManagerCore {
  DiffComponents age(CalendarManager instance) {
    final birthday = instance.clone();
    birthday.name(_self.name());

    final today = _self.getDateTime();
    final birth = birthday.getDateTime();

    var seconds = today.second - birth.second;
    var minutes = today.minute - birth.minute;
    var hours = today.hour - birth.hour;
    var days = today.day - birth.day;
    var months = today.month - birth.month;
    var years = today.year - birth.year;

    if (seconds < 0) {
      seconds += Constants.SecondsPerMinute;
      minutes -= 1;
    }

    if (minutes < 0) {
      minutes += Constants.MinutesPerHour;
      hours -= 1;
    }

    if (hours < 0) {
      hours += Constants.HoursPerDay;
      days -= 1;
    }

    if (days < 0) {
      months -= 1;
      // Days of the month before today's month (December of the previous
      // year when today is in the first month).
      final prevYear = today.month == 1 ? today.year - 1 : today.year;
      final prevMonth = today.month == 1 ? 12 : today.month - 1;
      days += birthday._currentCalendar.daysInMonth(prevYear, prevMonth);
    }

    if (months < 0) {
      months += 12;
      years -= 1;
    }

    return DiffComponents(years, months, days, hours, minutes, seconds);
  }

  DiffComponents diff(CalendarManager instance) {
    final seconds = diffInSeconds(instance);
    final minutes = seconds ~/ Constants.SecondsPerMinute;
    final hours = seconds ~/ Constants.HourInSeconds;
    final days = seconds ~/ Constants.DayInSeconds;
    final months = (days / Constants.MonthInDays).floor();
    final years = (days / Constants.YearInDays).floor();

    return DiffComponents(years, months, days, hours, minutes, seconds);
  }

  int diffInSeconds(CalendarManager instance) =>
      (_timestamp - instance._timestamp).abs();

  int diffInMinutes(CalendarManager instance) =>
      diffInSeconds(instance) ~/ Constants.SecondsPerMinute;

  int diffInHours(CalendarManager instance) =>
      diffInSeconds(instance) ~/ Constants.HourInSeconds;

  int diffInDays(CalendarManager instance) =>
      diffInSeconds(instance) ~/ Constants.DayInSeconds;

  int diffInMonths(CalendarManager instance) =>
      diffInSeconds(instance) ~/ Constants.MonthInSeconds;

  int diffInYears(CalendarManager instance) =>
      diffInSeconds(instance) ~/ Constants.YearInSeconds;

  String diffForHumans(CalendarManager instance) {
    bool before;
    CalendarManager base, other;
    final result = <String>[];
    const space = ' ';
    final defaultCalendar = _self.name();
    final now = Pasoonate.make();

    if (_self.beforeThan(instance)) {
      before = false;
      base = instance.clone();
      other = _self.clone();
    } else {
      before = true;
      base = _self.clone();
      other = instance.clone();
    }

    base.name(defaultCalendar);
    other.name(defaultCalendar);
    now.name(defaultCalendar);

    final age = base.age(other);
    String t(String key) => '${Pasoonate.trans('diff.$key')}';

    if (age.years > 0) result.add('${age.years}$space${t('year')}');
    if (age.months > 0) result.add('${age.months}$space${t('month')}');
    if (age.days > 0) result.add('${age.days}$space${t('day')}');
    if (age.hours > 0) result.add('${age.hours}$space${t('hour')}');
    if (age.minutes > 0) result.add('${age.minutes}$space${t('minute')}');
    if (age.seconds > 0) result.add('${age.seconds}$space${t('second')}');

    if (result.isEmpty) {
      result.add(t('now'));
    } else if (now.diff(base).minutes == 0 || now.diff(other).minutes == 0) {
      result.add(before ? t('ago') : t('from_now'));
    } else {
      result.add(before ? t('before') : t('after'));
    }

    return result.join(space);
  }
}
