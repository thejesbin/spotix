import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotix/models/account_model.dart';
import 'package:spotix/services/account_services.dart';

class AccountViewmodel extends GetxController {
  var accountList = <AccountModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value = true;
    var data = await AccountServices().getAccount();
    try {
      if (data != null) {
        accountList.value = data;
        isLoading.value = false;
        isEmpty.value = false;
         SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
        var uname=sharedPreferences.getString("uname");
        if(uname==null){
          sharedPreferences.setString("uname", data[0].name.toString());
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Exception", e.toString());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }
}
