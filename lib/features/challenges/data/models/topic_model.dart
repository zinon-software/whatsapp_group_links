class TopicModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int questionCount;

  TopicModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.questionCount,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      questionCount: json['question_count'],
    );
  }

  Map<String, dynamic> toJson({String? id}) {
    return {
      'id': id ?? this.id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'question_count': questionCount,
    };
  }

  static TopicModel empty() {
    return TopicModel(
      id: '',
      title: '====== ====  ===',
      description: '== ===================== ======== =',
      imageUrl: 'https://via.placeholder.com/150',
      questionCount: 0,
    );
  }
}
