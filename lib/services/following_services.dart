import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/following_model.dart';

class FollowingServices {
  Future<List<FollowingModel>?> getFollowing() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey), "uid": encrypt(uid!)});
    var response = await dio.post(followingUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data["result"] != null) {
        final followingList = (response.data['result'] as List).map((e) {
          return FollowingModel.fromJson(e);
        }).toList();
        return followingList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
