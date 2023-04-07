import 'package:get/get.dart';
import 'package:spotix/models/followers_model.dart';
import 'package:spotix/services/followers_services.dart';

class FollowersViewmodel extends GetxController {
  var followersList = <FollowersModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value = true;
    var data = await FollowersServices().getFollowers();
    try {
      if (data != null) {
        followersList.value = data;
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
