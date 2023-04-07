import 'package:dio/dio.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/comments_model.dart';

class CommentsServices {
  Future<List<CommentsModel>?> getComments(String pid) async {

    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey), "pid": encrypt(pid)});
    var response = await dio.post(commentsUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data["result"] );
      if (response.data["result"] != null) {
        final commentsList = (response.data['result'] as List).map((e) {
          return CommentsModel.fromJson(e);
        }).toList();
        return commentsList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
