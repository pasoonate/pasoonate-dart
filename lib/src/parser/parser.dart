import '../calendar_manager.dart';

/// Base parser. Extend it and register with `Pasoonate.setParser()`.
abstract class Parser {
  CalendarManager? calendar;

  void parse(String format, String text);
}
