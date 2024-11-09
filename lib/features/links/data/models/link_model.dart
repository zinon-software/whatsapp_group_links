import 'package:cloud_firestore/cloud_firestore.dart';

class LinkModel {
  final String id;
  final String? user;
  late String title;
  late DateTime createDt;
  late String url;
  late int views;
  late String type;
  late bool isActive;

  LinkModel({
    required this.id,
    this.user,
    required this.title,
    required this.createDt,
    required this.url,
    required this.views,
    required this.type,
    required this.isActive,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
        id: json["id"],
        user: json["user"],
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
      'user': user,
      'title': title,
      'create_dt': createDt,
      'url': url,
      'views': views,
      'type': type,
      'is_active': isActive
    };
  }

  LinkModel copyWith(
    {
      String? id,
      String? user,
      String? title,
      DateTime? createDt,
      String? url,
      int? views,
      String? type,
      bool? isActive,
    }
  ) {
    return LinkModel(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      createDt: createDt ?? this.createDt,
      url: url ?? this.url,
      views: views ?? this.views,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
    );
  }
}
