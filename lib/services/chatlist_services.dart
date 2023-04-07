import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/chatlist_model.dart';

class ChatlistServices {
  Future<List<ChatlistModel>?> getChatlist() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey), "uid": encrypt(uid!)});
    var response = await dio.post(chatlistUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data["chats"]);
      if (response.data["chats"] != null) {
        final chatlistList = (response.data['chats'] as List).map((e) {
          return ChatlistModel.fromJson(e);
        }).toList();
        return chatlistList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
