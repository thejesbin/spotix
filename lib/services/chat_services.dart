import 'package:dio/dio.dart';

import '../core/constants.dart';
import '../core/security.dart';
import '../models/chat_models.dart';

class ChatServices {
  Future<List<ChatModel>?> getChats(receiverId, senderId) async {
    Dio dio = Dio();
    var formData = FormData.fromMap({
      "api": encrypt(apiKey),
      "sender_id": encrypt(senderId),
      "receiver_id": encrypt(receiverId)
    });
     var response = await dio.post(chatsUrl, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data['chats']);
      final chatList = (response.data['chats'] as List).map((e) {
        return ChatModel.fromJson(e);
      }).toList();
      return chatList;
    } else {
      return null;
    }
  }
}
