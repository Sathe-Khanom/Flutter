class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  // JSON থেকে Category তৈরি করার factory method
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  // Category কে JSON format এ রূপান্তর করার method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
