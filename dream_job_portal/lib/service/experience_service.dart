import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/experience.dart';
import 'authservice.dart';
// Ensure this path is correct

class ExperienceService {
  // 🛠️ Note: Replace with your actual base URL
  final String _baseUrl = 'http://localhost:8085/api/experience/';

  // Helper to fetch the authentication token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // Use the same key ('authToken') as used in your Angular service
    return prefs.getString('authToken');
  }

  // Helper to create authenticated headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    };
    if (token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return headers;
  }

  // --- 1. Add Experience (POST) ---
  Future<Experience> addExperience(Experience exp) async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse('${_baseUrl}add'),
      headers: headers,
      body: jsonEncode(exp.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Experience.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please log in again.');
    } else {
      throw Exception('Failed to add experience: ${response.body}');
    }
  }

  //update

  Future<Experience> updateExperience(Experience exp) async {
    String? token = await AuthService().getToken();
    print(exp);
    final response = await http.put(
      // Assuming your backend update endpoint is PUT /api/training/{id}

      Uri.parse('${_baseUrl}update/${exp.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(exp.toJson()),
    );

    print('📡 Update Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Assuming the backend returns the updated Training object
      return Experience.fromJson(json.decode(response.body));
    } else {
      print('❌ Update failed: ${response.body}');
      throw Exception('Failed to update training: ${response.statusCode}');
    }
  }

  // --- 2. Get all experiences for current JobSeeker (GET) ---
  Future<List<Experience>> getAllExperiences() async {
    final headers = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse('${_baseUrl}all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Experience.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please log in.');
    } else {
      throw Exception('Failed to load experiences: ${response.body}');
    }
  }

  // --- 3. Delete by ID (DELETE) ---
  Future<void> deleteExperience(int id) async {
    final headers = await _getAuthHeaders();

    final response = await http.delete(
      Uri.parse('$_baseUrl$id'),
      headers: headers,
    );

    // Angular's delete returns Observable<void>, Flutter's returns Future<void>
    if (response.statusCode == 200 || response.statusCode == 204) {
      return; // Success
    } else if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please log in.');
    } else {
      throw Exception('Failed to delete experience: ${response.body}');
    }
  }
}