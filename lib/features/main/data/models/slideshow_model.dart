class SlideshowModel {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String route;
  final String url;

  SlideshowModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.route,
    required this.url,
  });

  factory SlideshowModel.fromJson(Map<String, dynamic> json) => SlideshowModel(
        id: json['id'],
        imageUrl: json['image_url'],
        title: json['title'],
        description: json['description'],
        route: json['route'],
        url: json['url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_url': imageUrl,
        'title': title,
        'description': description,
        'route': route,
        'url': url,
      };

  SlideshowModel copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? description,
    String? route,
    String? url,
  }) {
    return SlideshowModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      route: route ?? this.route,
      url: url ?? this.url,
    );
  }

  static SlideshowModel empty() {
    return SlideshowModel(
      id: '',
      imageUrl: '',
      title: '',
      description: '',
      route: '',
      url: '',
    );
  }
}
