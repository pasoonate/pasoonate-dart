import 'package:pasoonate/pasoonate.dart';

void main() {
  final now = Pasoonate.make();

  print(now.gregorian().format('yyyy-MM-dd')); // e.g. 2026-11-11
  print(now.jalali().format('yyyy/MM/dd dddd')); // e.g. 1405/08/20 چهارشنبه

  // Parse a Jalali date and read it as Gregorian.
  final dateTime =
      Pasoonate.make().jalali('1398-02-01 20:00:00').gregorian().getDateTime();
  print(dateTime); // DateTimeComponents{year: 2019, month: 4, day: 21, ...}

  // Arithmetic and modifiers.
  print(Pasoonate.make()
      .jalali('1399-01-15 11:22:00')
      .addYear(1)
      .endOfMonth()
      .format('yyyy/MM/dd HH:mm:ss')); // 1400/01/31 23:59:59
}
