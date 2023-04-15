class NotificationsModel {
  String? id;
  String? uid;
  String? fid;
  String? title;
  String? date;
  String? time;
  String? isReaded;
  String? profile;

  NotificationsModel({
    this.id,
    this.fid,
    this.uid,
    this.title,
    this.date,
    this.time,
    this.isReaded,
    this.profile,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      id: json['id'],
      fid: json['fid'],
      uid: json['uid'],
      title: json['title'],
      date: json['date'],
      time: json['time'],
      isReaded: json['isReaded'],
      profile: json['profile'],
    );
  }
}
