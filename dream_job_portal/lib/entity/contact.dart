class ContactMessage {
  final int? id;
  final String name;
  final String email;
  final String message;

  ContactMessage({
    this.id,
    required this.name,
    required this.email,
    required this.message,
  });

  // Factory constructor for converting JSON (from API) to ContactMessage object
  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
    );
  }

  // Method for converting ContactMessage object to JSON (to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'message': message,
    };
  }
}