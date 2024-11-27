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
  late bool isVerified;
  final bool isAd;
  final bool isVIP;

  LinkModel(
      {required this.id,
      this.user,
      required this.title,
      required this.createDt,
      required this.url,
      required this.views,
      required this.type,
      required this.isActive,
      this.isVerified = false,
      this.isAd = false,
      this.isVIP = false});

  factory LinkModel.fromJson(Map<String, dynamic> json) {
    LinkModel linkModel = LinkModel(
      id: json["id"],
      user: json["user"],
      title: json["title"],
      createDt: (json['create_dt'] as Timestamp).toDate(),
      url: json["url"],
      views: json["views"],
      type: json["type"],
      isActive: json["is_active"],
      isVerified: json["is_verified"] ?? false,
      isAd: json["is_ad"] ?? false,
      isVIP: json["is_vip"] ?? false,
    );

    linkModel = linkModel.copyWith(
      isVIP: linkModel.isVIP ? true : linkModel.views > 500,
    );

    return linkModel;
  }

  Map<String, dynamic> toJson({String? id}) {
    return {
      'id': id ?? this.id,
      'user': user,
      'title': title,
      'create_dt': createDt,
      'url': url,
      'views': views,
      'type': type,
      'is_active': isActive,
      'is_verified': isVerified,
      'is_ad': isAd,
      'is_vip': isVIP,
    };
  }

  LinkModel copyWith({
    String? id,
    String? user,
    String? title,
    DateTime? createDt,
    String? url,
    int? views,
    String? type,
    bool? isActive,
    bool? isVerified,
    bool? isAd,
    bool? isVIP,
  }) {
    return LinkModel(
        id: id ?? this.id,
        user: user ?? this.user,
        title: title ?? this.title,
        createDt: createDt ?? this.createDt,
        url: url ?? this.url,
        views: views ?? this.views,
        type: type ?? this.type,
        isActive: isActive ?? this.isActive,
        isVerified: isVerified ?? this.isVerified,
        isAd: isAd ?? this.isAd,
        isVIP: isVIP ?? this.isVIP);
  }

  static LinkModel isEmpty() {
    return LinkModel(
      id: '',
      user: '=====================',
      title: '--------------  ---',
      createDt: DateTime.now(),
      url: '',
      views: 100,
      type: 'whatsapp',
      isActive: true,
      isVerified: true,
    );
  }
}
