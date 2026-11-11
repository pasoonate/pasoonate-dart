// Checks the Dart port against values produced by the JavaScript package
// (see tool/generate_fixtures.mjs).
import 'dart:convert';
import 'dart:io';

import 'package:pasoonate/pasoonate.dart';
import 'package:test/test.dart';

Map<String, dynamic> _dt(DateTimeComponents d) => d.toMap();

void main() {
  final fixtures =
      jsonDecode(File('test/fixtures/js_reference.json').readAsStringSync())
          as Map<String, dynamic>;

  setUpAll(() => Pasoonate.localization.setLang('en', en));
  tearDown(() => Pasoonate.setLocale('fa'));

  CalendarManager make(int ts, int tz, String cal) =>
      Pasoonate.make(ts, tz)..name(cal);

  test('timestamp -> calendar date', () {
    for (final c in fixtures['conversions'] as List) {
      final m = make(c['ts'], c['tz'], c['cal']);
      final reason = '${c['cal']} ts=${c['ts']} tz=${c['tz']}';
      expect(_dt(m.getDateTime()), c['dateTime'], reason: reason);
      expect(_dt(m.getUTCDateTime()), c['utc'], reason: reason);
      expect(m.dayOfWeek(), c['dayOfWeek'], reason: reason);
      expect(m.dayOfYear(), c['dayOfYear'], reason: reason);
      // JS can return a fraction here; the Dart port floors it.
      expect(m.weekOfMonth(), (c['weekOfMonth'] as num).floor(),
          reason: reason);
      expect(m.weekOfYear(), (c['weekOfYear'] as num).floor(), reason: reason);
      expect(m.isLeapYear(), c['isLeapYear'], reason: reason);
      final d = m.getDateTime();
      expect(m.currentCalendar!.daysInMonth(d.year, d.month), c['daysInMonth'],
          reason: reason);
      expect(m.format('yyyy-MM-dd HH:mm:ss yy M d H m s'), c['format'],
          reason: reason);
    }
  });

  test('calendar date -> timestamp', () {
    for (final c in fixtures['toTimestamp'] as List) {
      final args = (c['args'] as List).cast<int>();
      final m = make(1600000000, 1, c['cal'])
        ..setUTCDateTime(args[0], args[1], args[2], args[3], args[4], args[5]);
      final reason = '${c['cal']} $args';
      expect(m.getTimestamp(), c['ts'], reason: reason);
      expect(_dt(m.getUTCDateTime()), c['back'], reason: reason);
    }
  });

  test('addition, subtraction and modifiers', () {
    for (final c in fixtures['operations'] as List) {
      final m = make(c['ts'], c['tz'], c['cal']);
      final int? arg = c['arg'];
      switch (c['op']) {
        case 'addYear':
          m.addYear(arg!);
        case 'addMonth':
          m.addMonth(arg!);
        case 'addDay':
          m.addDay(arg!);
        case 'addHour':
          m.addHour(arg!);
        case 'addMinute':
          m.addMinute(arg!);
        case 'addSecond':
          m.addSecond(arg!);
        case 'subYear':
          m.subYear(arg!);
        case 'subMonth':
          m.subMonth(arg!);
        case 'subDay':
          m.subDay(arg!);
        case 'subHour':
          m.subHour(arg!);
        case 'subMinute':
          m.subMinute(arg!);
        case 'subSecond':
          m.subSecond(arg!);
        case 'startOfDay':
          m.startOfDay();
        case 'endOfDay':
          m.endOfDay();
        case 'startOfMonth':
          m.startOfMonth();
        case 'endOfMonth':
          m.endOfMonth();
        case 'startOfYear':
          m.startOfYear();
        case 'endOfYear':
          m.endOfYear();
        case 'startOfWeek':
          m.startOfWeek();
        case 'endOfWeek':
          m.endOfWeek();
        default:
          fail('unknown op ${c['op']}');
      }
      expect(m.getTimestamp(), c['result'],
          reason: '${c['cal']} ts=${c['ts']} ${c['op']}($arg)');
    }
  });

  test('parsing', () {
    for (final c in fixtures['parsing'] as List) {
      final m = make(1600000000, c['tz'], c['cal'])
        ..parse(c['pattern'], c['text']);
      expect(m.getTimestamp(), c['ts'], reason: '${c['cal']} ${c['text']}');
    }
  });

  test('formatting with names', () {
    for (final c in fixtures['formatting'] as List) {
      Pasoonate.setLocale(c['locale']);
      final m = make(c['ts'], c['tz'], c['cal']);
      expect(m.format('dddd ddd d MMMM MMM yyyy'), c['result'],
          reason: '${c['cal']} ${c['locale']} ts=${c['ts']}');
    }
  });

  test('differences', () {
    for (final c in fixtures['differences'] as List) {
      final x = make(c['a'], c['tz'], c['cal']);
      final y = make(c['b'], c['tz'], c['cal']);
      final reason = '${c['cal']} a=${c['a']} b=${c['b']}';
      expect(x.diff(y).toMap(), c['diff'], reason: reason);
      if (c['age'] != null) expect(x.age(y).toMap(), c['age'], reason: reason);
      expect(x.diffInSeconds(y), c['diffInSeconds'], reason: reason);
      expect(x.diffInMinutes(y), c['diffInMinutes'], reason: reason);
      expect(x.diffInHours(y), c['diffInHours'], reason: reason);
      expect(x.diffInDays(y), c['diffInDays'], reason: reason);
      expect(x.diffInMonths(y), c['diffInMonths'], reason: reason);
      expect(x.diffInYears(y), c['diffInYears'], reason: reason);
    }
  });
}
