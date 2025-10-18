class Training {
  final int? id;
  final String title;
  final String institute;
  final String duration;
  final String description;

  Training({
    this.id,
    required this.title,
    required this.institute,
    required this.duration,
    required this.description,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'],
      title: json['title'],
      institute: json['institute'],
      duration: json['duration'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'institute': institute,
      'duration': duration,
      'description': description,
    };
  }
}
