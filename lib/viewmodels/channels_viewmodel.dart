import 'package:get/get.dart';
import 'package:spotix/models/channels_model.dart';
import 'package:spotix/services/channels_services.dart';

class ChannelsViewmodel extends GetxController {
  var channelsList = <ChannelsModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value = true;
    var data = await ChannelsServices().getChannels();
    try {
      if (data != null) {
        channelsList.value = data;
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
