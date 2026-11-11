import 'package:pasoonate/pasoonate.dart';
import 'package:test/test.dart';

void main() {
  // 2019-04-19 09:33:20 UTC, Tehran offset (+03:30).
  const ts = 1555666400;
  const tehran = 12600;

  tearDown(() {
    Pasoonate.setLocale('fa');
    Pasoonate.setFormatter(null);
    Pasoonate.setParser(null);
  });

  group('conversion', () {
    test('timestamp to every calendar', () {
      final m = Pasoonate.make(ts, tehran);
      expect(
          m.gregorian().format('yyyy-MM-dd HH:mm:ss'), '2019-04-19 13:03:20');
      expect(m.jalali().format('yyyy-MM-dd'), '1398-01-30');
      expect(m.islamic().format('yyyy-MM-dd'), '1440-08-13');
      expect(m.shia().format('yyyy-MM-dd'), '1440-08-13');
    });

    test('jalali string to gregorian', () {
      final d = Pasoonate.make(ts, tehran)
          .jalali('1398-02-01 20:00:00')
          .gregorian()
          .getDateTime();
      expect(d, DateTimeComponents(2019, 4, 21, 20, 0, 0));
    });

    test('nowruz 1403 and leap years', () {
      final m = Pasoonate.make(ts, 0)..gregorian('2024-03-20 00:00:00');
      expect(m.jalali().getDate(), const DateComponents(1403, 1, 1));
      expect(m.isLeapYear(), isTrue);
      expect(m.subDay(1).getDate(), const DateComponents(1402, 12, 29));
      expect(Pasoonate.make(ts, 0).jalali('1399-12-30 00:00:00').getDate(),
          const DateComponents(1399, 12, 30));
    });

    test('UTC getters ignore the timezone offset', () {
      final m = Pasoonate.make(ts, tehran).gregorian();
      expect(m.getUTCTime(), const TimeComponents(9, 33, 20));
      expect(m.getTime(), const TimeComponents(13, 3, 20));
    });

    test('a timezone offset of 0 is UTC', () {
      expect(Pasoonate.make(ts, 0).getTimezoneOffset(), 0);
    });
  });

  group('formatting', () {
    test('persian names', () {
      expect(Pasoonate.make(ts, tehran).jalali().format('dddd d MMMM yyyy'),
          'جمعه 30 فروردین 1398');
    });

    test('english names', () {
      Pasoonate.localization.setLang('en', en);
      Pasoonate.setLocale('en');
      expect(Pasoonate.make(ts, tehran).jalali().format('d MMMM yy'),
          '30 Farvardin 98');
    });

    test('locale argument', () {
      Pasoonate.localization.setLang('en', en);
      expect(Pasoonate.make(ts, tehran).jalali().format('MMMM', 'en'),
          'Farvardin');
    });

    test('custom formatter', () {
      Pasoonate.setFormatter(DateFormat());
      expect(
          Pasoonate.make(ts, tehran).gregorian().format(), '2019-4-19 13:3:20');
    });
  });

  group('parsing', () {
    test('month names', () {
      final m = Pasoonate.make(ts, 0).jalali()
        ..parse('d MMMM yyyy', '5 مهر 1400');
      expect(m.getDate(), const DateComponents(1400, 7, 5));
    });

    test('other separators', () {
      final m = Pasoonate.make(ts, 0).gregorian()
        ..parse('dd/MM/yyyy HH:mm', '31/12/1999 23:59');
      expect(m.getDateTime(), DateTimeComponents(1999, 12, 31, 23, 59, 20));
    });
  });

  group('arithmetic and modifiers', () {
    test('README examples', () {
      String f(CalendarManager m) => m.format('yyyy/MM/dd HH:mm:ss');
      final m = Pasoonate.make(ts, tehran).jalali('1399-01-15 11:22:00');
      expect(f(m.addYear(1)), '1400/01/15 11:22:00');
      expect(f(m.addMonth(1)), '1400/02/15 11:22:00');
      expect(f(m.addDay(3)), '1400/02/18 11:22:00');
      expect(f(m.addHour(4)), '1400/02/18 15:22:00');
      expect(f(m.subYear(1)), '1399/02/18 15:22:00');
      expect(f(m.subMonth(1)), '1399/01/18 15:22:00');
      expect(f(m.startOfDay()), '1399/01/18 00:00:00');
      expect(f(m.endOfDay()), '1399/01/18 23:59:59');
      expect(f(m.endOfMonth()), '1399/01/31 23:59:59');
      expect(f(m.startOfYear()), '1399/01/01 00:00:00');
      expect(f(m.endOfYear()), '1399/12/30 23:59:59');
    });

    test('month overflow clamps the day', () {
      final m = Pasoonate.make(ts, 0).gregorian('2024-01-31 00:00:00');
      expect(m.addMonth(1).getDate(), const DateComponents(2024, 2, 29));
    });

    test('week starts on saturday', () {
      final m = Pasoonate.make(ts, tehran).jalali(); // friday
      expect(m.isFriday(), isTrue);
      expect(m.clone().jalali().startOfWeek().isSaturday(), isTrue);
      expect(m.endOfWeek().isFriday(), isTrue);
    });
  });

  group('comparison and difference', () {
    final a = Pasoonate.make(1600000000, 0).gregorian();
    final b = Pasoonate.make(1600003600, 0).gregorian();

    test('comparison', () {
      expect(a.beforeThan(b), isTrue);
      expect(b.afterThan(a), isTrue);
      expect(a.equal(a.clone()), isTrue);
      expect(a.min(b), same(a));
      expect(a.max(b), same(b));
      expect(a.isSameDay(b), isTrue);
    });

    test('diff', () {
      expect(a.diffInMinutes(b), 60);
      expect(a.diffInHours(b), 1);
      expect(a.diffInDays(b), 0);
    });

    test('age across the first month of the year', () {
      final today = Pasoonate.make(0, 0).gregorian('2024-01-05 00:00:00');
      final birthday = Pasoonate.make(0, 0).gregorian('2000-12-20 00:00:00');
      expect(today.age(birthday), const DiffComponents(23, 0, 16, 0, 0, 0));
    });

    test('diffForHumans', () {
      final x = Pasoonate.make(0, 0).gregorian('2000-01-01 00:00:00');
      final y = Pasoonate.make(0, 0).gregorian('2001-03-02 00:00:00');
      expect(y.diffForHumans(x), '1 سال 2 ماه 1 روز قبل');
      expect(x.diffForHumans(y), '1 سال 2 ماه 1 روز بعد');
      expect(x.diffForHumans(x.clone()), 'اکنون');
    });

    test('isToday / isTomorrow / isYesterday', () {
      expect(Pasoonate.make().gregorian().isToday(), isTrue);
      expect(Pasoonate.make().gregorian().addDay(1).isTomorrow(), isTrue);
      expect(Pasoonate.make().gregorian().subDay(1).isYesterday(), isTrue);
    });
  });

  group('misc', () {
    test('name()', () {
      final m = Pasoonate.make(ts, 0);
      expect(m.name(), '');
      expect(m.name('Jalali'), 'jalali');
      expect(m.name('unknown'), 'jalali');
    });

    test('using a manager without a calendar throws', () {
      expect(() => Pasoonate.make(ts, 0).getYear(), throwsStateError);
    });

    test('invalid month throws RangeError', () {
      expect(() => GregorianCalendar().daysInMonth(2020, 13), throwsRangeError);
    });

    test('trans falls back to the key', () {
      expect(Pasoonate.trans('missing.key'), 'missing.key');
      expect(Pasoonate.trans('diff.year'), 'سال');
    });
  });
}
