import 'package:get/get.dart';
import 'package:spotix/models/following_model.dart';
import 'package:spotix/services/following_services.dart';

class FollowingViewmodel extends GetxController {
  var followingList = <FollowingModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value = true;
    var data = await FollowingServices().getFollowing();
    try {
      if (data != null) {
        followingList.value = data;
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
