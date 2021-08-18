import 'package:flutter/cupertino.dart';

class SearchProvider with ChangeNotifier {
  String _keyword = '';

  String get keyword => _keyword;

  // ignore: non_constant_identifier_names
  set keyword(String newValue) {
    _keyword = newValue;
    notifyListeners();
  }
}
