class FollowersModel {
  String? id;
  String? username;
  String? profile;
  String? verified;

  FollowersModel({this.id, this.username, this.profile, this.verified});

  factory FollowersModel.fromJson(Map<String, dynamic> json) {
    return FollowersModel(
      id: json['id'],
      username: json['username'],
      profile: json['profile'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "profile": profile,
      "verified": verified,
    };
  }
}
