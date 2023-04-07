import 'package:get/get.dart';
import 'package:spotix/models/comments_model.dart';
import 'package:spotix/services/comments_services.dart';

class CommentsViewmodel extends GetxController {
  final String pid;
  CommentsViewmodel({required this.pid,});
  var commentsList = <CommentsModel>[].obs;
  var isLoading = true.obs;
  var isEmpty = true.obs;
  getData(pid2) async {
    isLoading.value=true;
    var data = await CommentsServices().getComments(pid2);
    try {
      if (data != null) {
        commentsList.value = data;
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
    getData(pid);
  }
}
