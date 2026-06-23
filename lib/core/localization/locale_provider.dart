import 'package:flutter/foundation.dart';
import 'app_strings.dart';

class LocaleProvider extends ChangeNotifier {
  String _lang = 'ar'; // default: Arabic

  String get lang => _lang;
  AppStrings get s => AppStrings.of(_lang);
  bool get isRtl => _lang == 'ar';

  void setLang(String code) {
    if (_lang == code) return;
    _lang = code;
    notifyListeners();
  }
}
