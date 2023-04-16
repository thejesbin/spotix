class ChatModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  ChatModel({this.id, this.senderId, this.receiverId, this.message});
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        id: json['id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        message: json['message']);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message
    };
  }
}
