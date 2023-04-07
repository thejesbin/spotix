class CommentsModel {
  String? cid;
  String? pid;
  String? uid;
  String? comment;
  String? profile;
  String? username;
  String? verified;

  CommentsModel(
      {this.cid,
      this.pid,
      this.uid,
      this.comment,
      this.username,
      this.profile,
      this.verified});

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      cid: json['cid'],
      pid: json['pid'],
      uid: json['uid'],
      comment: json['comment'],
      username: json['username'],
      profile: json['profile'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cid": cid,
      "pid": pid,
      "uid": uid,
      "comment": comment,
      "username": username,
      "profile": profile,
      "verified": verified,
    };
  }
}
