class PhotosModel {
  String? id;
  String? pid;
  String? uid;
  String? url;
  String? likes;
  String? comments;
  String? isLiked;
  String? caption;
  String? type;
  String? username;
  String? profile;
  String? verified;

  PhotosModel(
      {this.id,
      this.pid,
      this.uid,
      this.url,
      this.likes,
      this.comments,
      this.isLiked,
      this.caption,
      this.type,
      this.username,
      this.profile,
      this.verified});

  factory PhotosModel.fromJson(Map<String, dynamic> json) {
    return PhotosModel(
      id: json['id'],
      pid: json['pid'],
      uid: json['uid'],
      url: json['url'],
      likes: json['likes'],
      comments: json['comments'],
      isLiked: json['isLiked'],
      caption: json['caption'],
      type: json['type'],
      username: json['username'],
      profile: json['profile'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "pid": pid,
      "uid": uid,
      "url": url,
      "likes": likes,
      "comments": comments,
      "isLiked": isLiked,
      "caption": caption,
      "type": type,
      "username": username,
      "profile": profile,
      "verified": verified,
    };
  }
}
