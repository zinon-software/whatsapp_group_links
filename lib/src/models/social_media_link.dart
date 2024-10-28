import 'package:cloud_firestore/cloud_firestore.dart';

class SocialMediaLink {
  String? documentId;
  late String title;
  late DateTime createDt;
  late String url;
  late int views;
  late String type;
  late bool isActive;

  SocialMediaLink({
    this.documentId,
    required this.title,
    required this.createDt,
    required this.url,
    required this.views,
    required this.type,
    required this.isActive,
  });

  factory SocialMediaLink.fromJson(Map<String, dynamic> json ) =>
      SocialMediaLink(
        title: json["title"],
        createDt: (json['createDt'] as Timestamp).toDate(),
        url: json["url"],
        views: json["views"],
        type: json["type"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'createDt': createDt,
      'url': url,
      'views': views,
      'type': type,
      'isActive': isActive
    };
  }
}
