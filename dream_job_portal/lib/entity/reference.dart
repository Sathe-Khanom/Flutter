// This file defines the data structure for a Reference (e.g., a professional contact).

class Reference {
  final int id;
  final String name;
  final String contact;
  final String relation;

  Reference({
    required this.id,
    required this.name,
    required this.contact,
    required this.relation,
  });

  /// Factory constructor to create a Reference instance from a JSON map (for API response).
  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      // Ensure 'id' is treated as an integer
      id: json['id'] as int,
      // Safely handle potential nulls for string fields
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
      relation: json['relation'] ?? '',
    );
  }

  /// Converts the Reference instance to a JSON map (for sending in POST/PUT requests).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'relation': relation,
    };
  }
}
