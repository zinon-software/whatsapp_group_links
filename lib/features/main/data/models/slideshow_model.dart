class SlideshowModel {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String route;

  SlideshowModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.route,
  });

  factory SlideshowModel.fromJson(Map<String, dynamic> json) => SlideshowModel(
        id: json['id'],
        imageUrl: json['image_url'],
        title: json['title'],
        description: json['description'],
        route: json['route'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_url': imageUrl,
        'title': title,
        'description': description,
        'route': route,
      };

  SlideshowModel copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? description,
    String? route,
  }) {
    return SlideshowModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      route: route ?? this.route,
    );
  }

  static SlideshowModel empty() {
    return SlideshowModel(
      id: '',
      imageUrl: '',
      title: '',
      description: '',
      route: '',
    );
  }
}
