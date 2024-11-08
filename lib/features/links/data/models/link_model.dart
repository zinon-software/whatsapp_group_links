import 'package:cloud_firestore/cloud_firestore.dart';

class LinkModel {
  final String id;
  late String title;
  late DateTime createDt;
  late String url;
  late int views;
  late String type;
  late bool isActive;

  LinkModel({
    required this.id,
    required this.title,
    required this.createDt,
    required this.url,
    required this.views,
    required this.type,
    required this.isActive,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
        id: json["id"],
        title: json["title"],
        createDt: (json['create_dt'] as Timestamp).toDate(),
        url: json["url"],
        views: json["views"],
        type: json["type"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson({String? id}) {
    return {
      'id': id ?? this.id,
      'title': title,
      'create_dt': createDt,
      'url': url,
      'views': views,
      'type': type,
      'is_active': isActive
    };
  }
}
