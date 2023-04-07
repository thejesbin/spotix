import 'package:get/get.dart';
import 'package:spotix/models/history_model.dart';
import 'package:spotix/services/history_services.dart';

class HistoryViewmodel extends GetxController {
  var historyList = <HistoryModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value=true;
    var data = await HistoryServices().getHistory();
    try {
      if (data != null) {
        historyList.value = data;
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
