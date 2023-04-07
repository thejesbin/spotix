class AccountModel {
  String? followers;
  String? following;
  String? posts;
  String? name;
  String? bio;
  String? profile;
  String? username;
  String? isVerified;
  String? phone;
String? id;
  String? email;

  String? balance;

  List<Photos>? photos;
  List<Videos>? videos;
  AccountModel(
      {this.photos,
      this.followers,
      this.following,
      this.posts,
      this.name,
      this.bio,
      this.profile,
      this.isVerified,
      this.phone,
      this.email,
      this.balance,
      this.videos,
      this.username,this.id});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      followers: json['followers'],
      following: json['following'],
      posts: json['posts'],
      name: json['name'],
      bio: json['bio'],
      profile: json['profile'],
      username: json['username'],
      isVerified: json['verified'],
      phone: json['phone'],
      email: json['email'],
      balance: json['balance'],
      id: json['id'],

      photos: json['photos'] != null
          ? List<Photos>.from(json["photos"].map((x) => Photos.fromJson(x)))
          : null,
      videos: json['videos'] != null
          ? List<Videos>.from(json["videos"].map((x) => Videos.fromJson(x)))
          : null,
    );
  }
}

class Photos {
  String? id;
  String? url;

  String? uid;
  String? pid;
  String? likes;
  String? comments;
  String? isLiked;
  String? caption;
  String? type;
  String? name;
  String? profile;
  String? verified;
  Photos({
    this.url,
    this.id,
    this.uid,
    this.pid,
    this.likes,
    this.comments,
    this.isLiked,
    this.caption,
    this.type,
    this.name,
    this.profile,
    this.verified,
  });
  //fromJson method
  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      id: json['id'],
      pid: json['pid'],
      uid: json['uid'],
      url: json['url'],
      likes: json['likes'],
      comments: json['comments'],
      isLiked: json['isLiked'],
      caption: json['caption'],
      type: json['type'],
      name: json['name'],
      profile: json['profile'],
      verified: json['verified'],
    );
  }
}

class Videos {
  String? id;
  String? url;
  String? thumbnail;
  String? uid;
  String? pid;
  String? likes;
  String? comments;
  String? isLiked;
  String? caption;
  String? type;
  String? name;
  String? profile;
  String? verified;
  Videos(
      {this.url,
      this.id,
      this.uid,
      this.pid,
      this.likes,
      this.comments,
      this.isLiked,
      this.caption,
      this.type,
      this.name,
      this.profile,
      this.verified,
      this.thumbnail});
  //fromJson method
  factory Videos.fromJson(Map<String, dynamic> json) {
    return Videos(
      id: json['id'],
      pid: json['pid'],
      uid: json['uid'],
      url: json['url'],
      likes: json['likes'],
      comments: json['comments'],
      isLiked: json['isLiked'],
      caption: json['caption'],
      type: json['type'],
      name: json['name'],
      profile: json['profile'],
      verified: json['verified'],
      thumbnail: json['thumbnail'],
    );
  }
}
