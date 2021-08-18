import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class ProgressProvider with ChangeNotifier {
  double _progress = 0.0;

  double get progress => _progress;

  // ignore: non_constant_identifier_names
  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }
}
