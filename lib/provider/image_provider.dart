import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/models/search_model.dart';

class ImageProviders with ChangeNotifier {
  Future<SearchModel> getResult(String keyword) async {
    try {
      var endPoint =
          Uri.parse("http://noire-xv.herokuapp.com/googleimages?q=$keyword");
      var response = await http.get(endPoint);

      print("Response status code ${response.statusCode}");
      print("response body : ${response.body} ");

      var parsedJson = await jsonDecode(response.body);
      SearchModel model = SearchModel.fromJson(parsedJson);

      print("MODEL : $model");
      print("MODEL LENGTH : ${model.result.length}");

      return model;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
