class Location {
  final int? id; // make nullable and optional
  final String name;

  Location({
    this.id,          // optional id
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // include id only if it's not null
      'name': name,
    };
  }
}
