import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/search_model.dart';

class SearchServices {
  Future<List<SearchModel>?> getSearch(String search) async {
    if (search.isNotEmpty) {
      Dio dio = Dio();
      var formData =
          FormData.fromMap({"api": encrypt(apiKey), "search": encrypt(search)});
      var response = await dio.post(searchUrl, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data["result"] != null) {
          final searchList = (response.data['result'] as List).map((e) {
            return SearchModel.fromJson(e);
          }).toList();
          return searchList;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }
}
