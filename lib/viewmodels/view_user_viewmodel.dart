import 'package:get/get.dart';
import 'package:spotix/models/view_user_model.dart';
import 'package:spotix/services/view_user_services.dart';

class ViewUserViewmodel extends GetxController {
  final String fid;
  ViewUserViewmodel({required this.fid});
  var viewUserList = <ViewUserModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value = true;
    var data = await ViewUserServices().getViewUser(fid);
    try {
      if (data != null) {
        viewUserList.value = data;
        isLoading.value = false;
        isEmpty.value = false;
       
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
