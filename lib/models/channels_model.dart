class ChannelsModel {
  String? id;
  String? name;
  String? logo;
  String? url;
  String? language;

  ChannelsModel({
    this.id,
    this.logo,
    this.name,
    this.url,
    this.language,
  });

  factory ChannelsModel.fromJson(Map<String, dynamic> json) {
    return ChannelsModel(
      id: json['id'],
      logo: json['logo'],
      name: json['name'],
      url: json['url'],
      language: json['language'],
    );
  }
}
