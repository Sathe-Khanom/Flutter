class Hobby {
  final int? id;
  final String name;

  Hobby({
    this.id, // Optional, can be null
    required this.name, // Required
  });

  // Optional: A simple factory to create an instance with only a name
  factory Hobby.createWithName(String name) {
    return Hobby(name: name);
  }

  // --- Recommended for JSON/Map operations ---

  // Convert from JSON/Map
  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
    );
  }

  // Convert to JSON/Map
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // Only include 'id' if it's not null
      'name': name,
    };
  }
}