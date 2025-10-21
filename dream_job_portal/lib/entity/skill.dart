// This file defines the data structure for a Skill.

class Skill {
  final int id;
  final String name;
  final String level;

  Skill({
    required this.id,
    required this.name,
    required this.level,
  });

  /// Factory constructor to create a Skill instance from a JSON map (for API response).
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      // Ensure 'id' is treated as an integer
      id: json['id'] as int,
      // Safely handle potential nulls for string fields
      name: json['name'] ?? '',
      level: json['level'] ?? '',
    );
  }

  /// Converts the Skill instance to a JSON map (for sending in POST/PUT requests).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
    };
  }
}
