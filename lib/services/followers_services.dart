import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/followers_model.dart';

class FollowersServices {
  Future<List<FollowersModel>?> getFollowers() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey), "uid": encrypt(uid!)});
    var response = await dio.post(followersUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data["result"] != null) {
        final followersList = (response.data['result'] as List).map((e) {
          return FollowersModel.fromJson(e);
        }).toList();
        return followersList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
