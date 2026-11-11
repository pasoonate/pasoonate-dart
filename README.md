# pasoonate

Date-time helpers and conversion between **Gregorian**, **Jalali**, **Islamic** and **Shia** calendars.
This is a pure Dart port of [pasoonate-js](https://github.com/pasoonate/pasoonate-js) and works in Flutter and plain Dart. It has no dependencies.

## Install

```yaml
dependencies:
  pasoonate:
    git: https://github.com/pasoonate/pasoonate-dart
```

## Usage

```dart
import 'package:pasoonate/pasoonate.dart';

final now = Pasoonate.make(); // current time, device timezone

now.gregorian().format('yyyy-MM-dd'); // 2019-04-19
now.jalali().format('yyyy/MM/dd dddd'); // 1398/01/30 جمعه

final dateTime = Pasoonate.make().jalali('1398-02-01 20:00:00').gregorian().getDateTime();
dateTime.year; // 2019
```

`Pasoonate.make([int? timestamp, int? timezoneOffset])` takes a Unix timestamp in **seconds** and a timezone offset in **seconds**, e.g. `12600` for Tehran (+03:30).
Both default to now and the device's timezone.

Methods return the same `CalendarManager`, so calls can be chained. Most methods mutate it in place; call `clone()` to keep the original.

## Available calendars

`gregorian([dateTime])`, `jalali([dateTime])`, `islamic([dateTime])`, `shia([dateTime])`.
The optional `dateTime` string is parsed as `yyyy-MM-dd HH:mm:ss`.

## Basic methods

- `getTimestamp()`, `getTimezoneOffset()`
- `getDateTime()`, `getDate()`, `getTime()`: returns `DateTimeComponents`, `DateComponents` or `TimeComponents`
- `getYear()`, `getMonth()`, `getDay()`, `getHour()`, `getMinute()`, `getSecond()`
- `getUTCDateTime()`, `getUTCDate()`, `getUTCTime()`, `getUTCYear()` … `getUTCSecond()`
- `setTimestamp(seconds)`, `setTimezoneOffset(seconds)`
- `setDateTime(y, m, d, h, i, s)`, `setDate(y, m, d)`, `setTime(h, i, s)`
- `setYear()` … `setSecond()`, plus the `setUTC…` variants
- `dayOfWeek()` (0 = Saturday … 6 = Friday), `dayOfYear()`, `weekOfMonth()`, `weekOfYear()`

## Addition and subtraction

`addYear`, `addMonth`, `addDay`, `addHour`, `addMinute`, `addSecond`,
`subYear`, `subMonth`, `subDay`, `subHour`, `subMinute`, `subSecond`.

```dart
Pasoonate.make().jalali('1399-01-15 11:22:00').addYear(1).format('yyyy/MM/dd HH:mm:ss');
// 1400/01/15 11:22:00
```

## Modifiers

`startOfDay`, `endOfDay`, `startOfMonth`, `endOfMonth`, `startOfYear`, `endOfYear`, `startOfWeek` (Saturday), `endOfWeek` (Friday).

## Comparison

`equal`, `afterThan`, `afterThanOrEqual`, `beforeThan`, `beforeThanOrEqual`, `between`, `min`, `max`,
`isWeekday`, `isWeekend`, `isSaturday` … `isFriday`, `isToday`, `isTomorrow`, `isYesterday`, `isFuture`, `isPast`, `isLeapYear`, `isSameDay`.

## Difference

`age(other)` and `diff(other)` return `DiffComponents`.
`diffInSeconds`, `diffInMinutes`, `diffInHours`, `diffInDays`, `diffInMonths` and `diffInYears` return an `int`.

```dart
a.diffForHumans(b); // 1 سال 2 ماه 1 روز قبل
```

## Format and parse

Tokens: `yyyy yy MMMM MMM MM M dddd ddd dd d HH H mm m ss s`. Any other character is copied as-is.

```dart
Pasoonate.make().jalali().format('dddd d MMMM yyyy'); // جمعه 30 فروردین 1398
Pasoonate.make().jalali().parse('d MMMM yyyy', '5 مهر 1400');
```

## Localization

`fa` is loaded by default. To use English names:

```dart
Pasoonate.localization.setLang('en', en);
Pasoonate.setLocale('en');
// or for one call: m.format('MMMM', 'en');
```

Custom formatters and parsers can be registered with `Pasoonate.setFormatter()` and `Pasoonate.setParser()`.

> Flutter's `intl` package also has a class named `DateFormat`. If you import both packages, add `hide DateFormat` to one of the imports.

## Differences from the JavaScript package

- A timestamp of `0` or a timezone offset of `0` is used as given. In JS, `0` meant "now" or "local timezone".
- `weekOfMonth()` and `weekOfYear()` always return an `int`.
- `format(pattern, locale)` uses the `locale` argument.
- Parsing month names with `MMMM` and `MMM` works.
- `age()` no longer fails when today is in the first month of the year.
- Using a manager before choosing a calendar throws a `StateError`.

## Tests

```bash
dart test
```

`test/js_reference_test.dart` checks thousands of conversions and operations against output from the JS package.
To regenerate that output, see `tool/generate_fixtures.mjs`.

## License

MIT
