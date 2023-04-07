import 'package:get/get.dart';
import 'package:spotix/models/videos_model.dart';
import 'package:spotix/services/videos_services.dart';

class VideosViewmodel extends GetxController {
  var videosList = <VideosModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value=true;
    var data = await VideosServices().getVideos();
    try {
      if (data != null) {
        videosList.value = data;
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
