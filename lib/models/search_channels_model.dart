class SearchChannelsModel {
  String? id;
  String? name;
  String? logo;
  String? url;
  String? language;
  SearchChannelsModel({this.id, this.name, this.logo, this.url, this.language});

  factory SearchChannelsModel.fromJson(Map<String, dynamic> json) {
    return SearchChannelsModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      url: json['url'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "logo": logo,
      "url": url,
      "language": language,
    };
  }
}
