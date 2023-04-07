class HistoryModel {
  String? id;
  String? uid;
  String? title;
  String? amount;
  String? transactionID;
  String? fid;
  String? date;
  String? time;
  String? type;
  String? profile;

  HistoryModel({
    this.id,
    this.title,
    this.uid,
    this.amount,
    this.transactionID,
    this.fid,
    this.date,
    this.time,
    this.type,
    this.profile,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      title: json['title'],
      uid: json['uid'],
      amount: json['amount'],
      transactionID: json['transaction_id'],
      fid: json['fid'],
      date: json['date'],
      time: json['time'],
      type: json['type'],
      profile: json['profile'],
    );
  }
}
