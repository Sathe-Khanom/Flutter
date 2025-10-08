class Location {
  final int id;
  final String name;

  Location({
    required this.id,
    required this.name,
  });

  // JSON থেকে Location তৈরি করার factory constructor
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
    );
  }

  // Location কে JSON format-এ রূপান্তর
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
