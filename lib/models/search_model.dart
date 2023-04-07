class SearchModel {
  String? id;
  String? username;
  String? profile;
  String? verified;

  SearchModel({this.id, this.username, this.profile, this.verified});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
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
