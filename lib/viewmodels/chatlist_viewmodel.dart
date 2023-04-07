import 'package:get/get.dart';
import 'package:spotix/models/chatlist_model.dart';
import 'package:spotix/services/chatlist_services.dart';

class ChatlistViewmodel extends GetxController {
  var chatList = <ChatlistModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value=true;
    var data = await ChatlistServices().getChatlist();
    try {
      if (data != null) {
        chatList.value = data;
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
