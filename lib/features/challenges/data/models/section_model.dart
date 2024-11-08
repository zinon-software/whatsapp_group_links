class SectionModel {
  final String id;
  final String title;
  final String imageUrl;
  final int questionCount;

  SectionModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.questionCount,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(  
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      questionCount: json['question_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'question_count': questionCount,
    };
  }
}
