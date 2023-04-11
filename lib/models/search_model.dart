class SearchModel {
  String? id;
  String? username;
  String? profile;
  String? verified;
  String? phone;
  SearchModel(
      {this.id, this.username, this.profile, this.verified, this.phone});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
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
