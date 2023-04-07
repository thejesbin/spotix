import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/view_user_model.dart';

class ViewUserServices {
  Future<List<ViewUserModel>?> getViewUser(String fid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    Dio dio = Dio();
    var formData = FormData.fromMap(
        {"api": encrypt(apiKey), "uid": encrypt(uid!), "fid": encrypt(fid)});
    var response = await dio.post(viewUserUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
      if (response.data != null) {
        final viewUserList = (response.data as List).map((e) {
          return ViewUserModel.fromJson(e);
        }).toList();
        return viewUserList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
