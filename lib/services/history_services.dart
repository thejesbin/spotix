import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/history_model.dart';

class HistoryServices {
  Future<List<HistoryModel>?> getHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey), "uid": encrypt(uid!)});
    var response = await dio.post(historyUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data["result"] != null) {
        final historyList = (response.data['result'] as List).map((e) {
          return HistoryModel.fromJson(e);
        }).toList();
        return historyList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
