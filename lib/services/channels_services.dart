import 'package:dio/dio.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/channels_model.dart';

class ChannelsServices {
  Future<List<ChannelsModel>?> getChannels() async {
    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey)});
    var response = await dio.post(channelsUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data["result"]);
      if (response.data["result"] != null) {
        final channelsList = (response.data['result'] as List).map((e) {
          return ChannelsModel.fromJson(e);
        }).toList();
        return channelsList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
