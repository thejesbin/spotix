class ChatlistModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  String? date;
  String? time;
  String? username;
  String? profile;
  String? verified;
  ChatlistModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.date,
    this.time,
    this.username,
    this.profile,
    this.verified,
  });

  factory ChatlistModel.fromJson(Map<String, dynamic> json) {
    return ChatlistModel(
        id: json['id'],
        senderId: json['sender_id'],
        receiverId: json['receiver_id'],
        message: json['message'],
        date: json['date'],
        time: json['time'],
        username: json['username'],
        profile: json['profile'],
        verified: json['verified']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "date": date,
      "time": time,
      "username": username,
      "profile": profile,
      "verified": verified
    };
  }
}
