// Generates test/fixtures/js_reference.json from the JavaScript package so the
// Dart port can be checked against it.
//
// Usage:
//   1. Copy pasoonate-js/src somewhere and add ".js" to its relative imports
//      (Node ESM needs them), plus a package.json with {"type":"module"}.
//   2. TZ=UTC node tool/generate_fixtures.mjs /path/to/that/src
import { writeFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { pathToFileURL } from 'node:url';

const src = resolve(process.argv[2]);
const P = (await import(pathToFileURL(`${src}/Pasoonate.js`))).default;
const en = (await import(pathToFileURL(`${src}/lang/en.js`))).default;
globalThis.Pasoonate = P; // the JS mixins use a global
P.localization.setLang('en', en);

// Deterministic pseudo random numbers.
let seed = 20261111;
const rand = () => (seed = (seed * 1103515245 + 12345) % 2147483648) / 2147483648;
const randInt = (a, b) => a + Math.floor(rand() * (b - a + 1));

const calendars = ['gregorian', 'jalali', 'islamic', 'shia'];
const offsets = [1, 12600, -18000]; // 1s instead of 0: JS treats 0 as "local"
const timestamps = [
  1555666400, 1600000000, 946684799, 946684800, 1700000000, 1735689600,
  1742500000, 1774000000, 2000000000, 86401, -1, -2208988800, 4102444800,
];
while (timestamps.length < 150) timestamps.push(randInt(-2208988800, 4102444800));

const conversions = [];
for (const ts of timestamps) {
  for (const tz of offsets) {
    for (const cal of calendars) {
      const c = P.make(ts, tz);
      c.name(cal);
      const dt = c.getDateTime();
      conversions.push({
        ts, tz, cal,
        dateTime: dt,
        utc: c.getUTCDateTime(),
        dayOfWeek: c.dayOfWeek(),
        dayOfYear: c.dayOfYear(),
        weekOfMonth: c.weekOfMonth(),
        weekOfYear: c.weekOfYear(),
        isLeapYear: c.isLeapYear(),
        daysInMonth: c._currentCalendar.daysInMonth(dt.year, dt.month),
        format: c.format('yyyy-MM-dd HH:mm:ss yy M d H m s'),
      });
    }
  }
}

const toTimestamp = [];
for (const cal of calendars) {
  const base = { gregorian: 2000, jalali: 1380, islamic: 1420, shia: 1420 }[cal];
  for (let i = 0; i < 100; i++) {
    const y = randInt(base - 120, base + 60);
    const mo = randInt(1, 12);
    const c = P.make(1600000000, 1);
    c.name(cal);
    const d = randInt(1, c._currentCalendar.daysInMonth(y, mo));
    const h = randInt(0, 23), mi = randInt(0, 59), s = randInt(0, 59);
    c.setUTCDateTime(y, mo, d, h, mi, s);
    toTimestamp.push({ cal, args: [y, mo, d, h, mi, s], ts: c.getTimestamp(), back: c.getUTCDateTime() });
  }
}

const ops = [
  ['addYear', 1], ['addYear', 3], ['addMonth', 1], ['addMonth', 11], ['addMonth', 25],
  ['addDay', 3], ['addHour', 30], ['addMinute', 90], ['addSecond', 3601],
  ['subYear', 1], ['subMonth', 1], ['subMonth', 12], ['subMonth', 14], ['subDay', 40],
  ['subHour', 5], ['subMinute', 61], ['subSecond', 59],
  ['startOfDay'], ['endOfDay'], ['startOfMonth'], ['endOfMonth'], ['startOfYear'],
  ['endOfYear'], ['startOfWeek'], ['endOfWeek'],
];
const operations = [];
for (const ts of timestamps.slice(0, 40)) {
  for (const cal of calendars) {
    for (const [op, arg] of ops) {
      const c = P.make(ts, 12600);
      c.name(cal);
      c[op](arg);
      operations.push({ ts, tz: 12600, cal, op, arg: arg ?? null, result: c.getTimestamp() });
    }
  }
}

const parsing = [];
const parseCases = [
  ['jalali', 'yyyy-MM-dd HH:mm:ss', '1398-02-01 20:00:00'],
  ['jalali', 'yyyy/MM/dd HH:mm:ss', '1399/01/15 11:22:00'],
  ['jalali', 'yyyy/M/d', '1403/12/30'],
  ['gregorian', 'yyyy-MM-dd HH:mm:ss', '2019-04-19 13:03:20'],
  ['gregorian', 'dd.MM.yyyy', '29.02.2024'],
  ['gregorian', 'yyyy-MM-dd', '1999-12-31'],
  ['islamic', 'yyyy-MM-dd HH:mm:ss', '1440-08-13 10:00:00'],
  ['shia', 'yyyy-MM-dd HH:mm:ss', '1446-09-01 00:00:00'],
  ['shia', 'yyyy-MM-dd', '1448-12-30'],
];
for (const [cal, pattern, text] of parseCases) {
  const c = P.make(1600000000, 12600);
  c.name(cal);
  c.parse(pattern, text);
  parsing.push({ cal, pattern, text, tz: 12600, ts: c.getTimestamp() });
}

const formatting = [];
for (const ts of timestamps.slice(0, 40)) {
  for (const cal of calendars) {
    for (const locale of ['fa', 'en']) {
      P.setLocale(locale);
      const c = P.make(ts, 12600);
      c.name(cal);
      formatting.push({ ts, tz: 12600, cal, locale, result: c.format('dddd ddd d MMMM MMM yyyy') });
    }
  }
}
P.setLocale('fa');

const differences = [];
for (let i = 0; i < 120; i++) {
  const a = timestamps[randInt(0, timestamps.length - 1)];
  const b = timestamps[randInt(0, timestamps.length - 1)];
  const cal = calendars[i % 4];
  const x = P.make(a, 12600); x.name(cal);
  const y = P.make(b, 12600); y.name(cal);
  let age = null;
  try { age = x.age(y); } catch (e) { age = null; } // JS throws for month 0
  differences.push({
    a, b, tz: 12600, cal,
    diff: x.diff(y), age,
    diffInSeconds: x.diffInSeconds(y), diffInMinutes: x.diffInMinutes(y),
    diffInHours: x.diffInHours(y), diffInDays: x.diffInDays(y),
    diffInMonths: x.diffInMonths(y), diffInYears: x.diffInYears(y),
  });
}

writeFileSync(
  new URL('../test/fixtures/js_reference.json', import.meta.url),
  JSON.stringify({ conversions, toTimestamp, operations, parsing, formatting, differences }),
);
console.log('conversions', conversions.length, 'toTimestamp', toTimestamp.length,
  'operations', operations.length, 'parsing', parsing.length,
  'formatting', formatting.length, 'differences', differences.length);
