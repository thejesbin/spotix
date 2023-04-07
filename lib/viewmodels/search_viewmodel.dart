import 'package:get/get.dart';
import 'package:spotix/models/search_model.dart';
import 'package:spotix/services/search_services.dart';

class SearchViewmodel extends GetxController {
  var searchList = <SearchModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData(String search) async {
    isLoading.value=true;
    isEmpty.value=true;
    var data = await SearchServices().getSearch(search);
    try {
      if (data != null) {
        searchList.value = data;
        isLoading.value = false;
        isEmpty.value = false;
      } else {
        isLoading.value = false;
        isEmpty.value=true;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Exception", e.toString());
    }
  }
}
