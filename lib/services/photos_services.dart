import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/photos_model.dart';

class PhotosServices {
  Future<List<PhotosModel>?> getPhotos() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey), "uid": encrypt(uid!)});
    var response = await dio.post(photosUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data["posts"] != null) {
        final photosList = (response.data['posts'] as List).map((e) {
          return PhotosModel.fromJson(e);
        }).toList();
        return photosList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
