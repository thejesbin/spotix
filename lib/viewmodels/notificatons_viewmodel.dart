import 'package:get/get.dart';
import 'package:spotix/models/notifications_model.dart';
import 'package:spotix/services/notifications_services.dart';

class NotificationsViewmodel extends GetxController {
  var notificationsList = <NotificationsModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData() async {
    isLoading.value = true;
    var data = await NotificationsServices().getNotifications();
    try {
      if (data != null) {
        notificationsList.value = data;
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
