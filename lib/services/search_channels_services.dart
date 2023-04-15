import 'package:dio/dio.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import '../models/search_channels_model.dart';

class SearchChannelsServices {
  Future<List<SearchChannelsModel>?> getSearch(String search) async {
    if (search.isNotEmpty) {
      Dio dio = Dio();
      var formData =
          FormData.fromMap({"api": encrypt(apiKey), "search": encrypt(search)});
      var response = await dio.post(searchChannelsUrl, data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data["result"] != null) {
          final searchChannelsList = (response.data['result'] as List).map((e) {
            return SearchChannelsModel.fromJson(e);
          }).toList();
          return searchChannelsList;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
    return null;
  }
}
