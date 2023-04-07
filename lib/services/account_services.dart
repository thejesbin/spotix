import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/core/constants.dart';
import 'package:spotix/core/security.dart';
import 'package:spotix/models/account_model.dart';

class AccountServices {
  Future<List<AccountModel>?> getAccount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var uid = sharedPreferences.getString("uid");
    Dio dio = Dio();
    var formData =
        FormData.fromMap({"api": encrypt(apiKey), "uid": encrypt(uid!)});
    var response = await dio.post(accountUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
      if (response.data != null) {
        final accountList = (response.data as List).map((e) {
          return AccountModel.fromJson(e);
        }).toList();
        return accountList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
