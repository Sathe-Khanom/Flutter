// This file defines the data structure for a Language,
// including methods for converting it to and from JSON.

class Language {
  final int id;
  final String name;
  final String proficiency;

  Language({
    required this.id,
    required this.name,
    required this.proficiency,
  });

  /// Factory constructor to create a Language instance from a JSON map (for API response).
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      // The API should guarantee 'id' is present and an int/num
      id: json['id'] as int,
      // Safely handle potential nulls for string fields
      name: json['name'] ?? '',
      proficiency: json['proficiency'] ?? '',
    );
  }

  /// Converts the Language instance to a JSON map (for sending in POST/PUT requests).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'proficiency': proficiency,
    };
  }
}
