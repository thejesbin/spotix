import 'package:get/get.dart';
import '../models/search_channels_model.dart';
import '../services/search_channels_services.dart';

class SearchChannelsViewmodel extends GetxController {
  var searchChannelsList = <SearchChannelsModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData(String search) async {
    isLoading.value = true;
    isEmpty.value = true;
    var data = await SearchChannelsServices().getSearch(search);
    try {
      if (data != null) {
        searchChannelsList.value = data;
        isLoading.value = false;
        isEmpty.value = false;
      } else {
        isLoading.value = false;
        isEmpty.value = true;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Exception", e.toString());
    }
  }
}
