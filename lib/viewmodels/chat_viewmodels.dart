import 'package:get/get.dart';

import '../models/chat_models.dart';
import '../services/chat_services.dart';

class ChatViewmodel extends GetxController {
  var chatList = <ChatModel>[].obs;
  var isLoading = true.obs;
  getData(senderId, receiverId) async {
    var data = await ChatServices().getChats(receiverId, senderId);
    if (data != null) {
      chatList.value = data;
      isLoading.value = false;
    }
  }
}
