import 'package:flutter/cupertino.dart';

class LoadingProvider with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  // ignore: non_constant_identifier_names
  set loading(bool newValue) {
    _loading = newValue;
    notifyListeners();
  }
}
