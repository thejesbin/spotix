import 'package:get/get.dart';
import 'package:spotix/models/photos_model.dart';
import 'package:spotix/services/photos_services.dart';

class PhotosViewmodel extends GetxController {
  var photosList = <PhotosModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value=true;
    var data = await PhotosServices().getPhotos();
    try {
      if (data != null) {
        photosList.value = data;
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
