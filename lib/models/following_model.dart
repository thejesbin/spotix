class FollowingModel {
  String? id;
  String? username;
  String? profile;
  String? verified;
  String? phone;

  FollowingModel(
      {this.id, this.username, this.profile, this.verified, this.phone});

  factory FollowingModel.fromJson(Map<String, dynamic> json) {
    return FollowingModel(
      id: json['id'],
      username: json['username'],
      profile: json['profile'],
      verified: json['verified'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "profile": profile,
      "verified": verified,
      "phone": phone,
    };
  }
}
