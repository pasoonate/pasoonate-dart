/// Holds translations and the current locale.
class Localization {
  final Map<String, Map<String, dynamic>> _langs = {};
  String _locale = 'fa';

  void setLang(String name, Map<String, dynamic> trans) {
    _langs[name] = trans;
  }

  void setLocale(String? locale) {
    _locale = locale ?? _locale;
  }

  String getLocale() => _locale;

  bool isLocale(String locale) => _locale == locale;

  /// Returns the value at the dotted [key] (e.g. `jalali.month_name.1`) or
  /// `null` when it does not exist.
  dynamic hasTransKey(String key, String locale) {
    dynamic result = _langs[locale];
    if (result == null) return null;

    for (final subKey in key.split('.')) {
      if (result is Map && result.containsKey(subKey)) {
        result = result[subKey];
      } else if (result is List) {
        final index = int.tryParse(subKey);
        if (index == null || index < 0 || index >= result.length) return null;
        result = result[index];
      } else {
        return null;
      }
    }

    return result;
  }

  /// Returns the translation, or the [key] itself when it is missing.
  dynamic getTrans(String key, String locale) {
    final result = hasTransKey(key, locale);
    return (result == null || result == '') ? key : result;
  }

  dynamic trans([String? key, String? locale]) =>
      getTrans(key ?? '', locale ?? _locale);
}
