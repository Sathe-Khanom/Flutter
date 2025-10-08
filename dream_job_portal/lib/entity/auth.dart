class AuthResponse {
  final String token;
  final String message;

  AuthResponse({
    required this.token,
    required this.message,
  });

  // JSON → AuthResponse
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      message: json['message'],
    );
  }

  // AuthResponse → JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'message': message,
    };
  }
}
