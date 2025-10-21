import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/extracurricular.dart';
import 'authservice.dart';

class ExtracurricularService {

  final String _baseUrl = 'http://localhost:8085/api/extracurricular/';


  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    // Assuming the token is stored under 'authToken'
    return prefs.getString('authToken');
  }

  // Helper function to generate authenticated headers
  Future<Map<String, String>> _getAuthHeaders({bool jsonContent = true}) async {
    final token = await _getToken();
    final Map<String, String> headers = {};

    if (jsonContent) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json; charset=UTF-8';
    }

    if (token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    return headers;
  }

  // --- 1. Add new extracurricular (POST) ---
  Future<Extracurricular> addExtracurricular(Extracurricular data) async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse('${_baseUrl}add'),
      headers: headers,
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Extracurricular.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add extracurricular: ${response.body}');
    }
  }

  // --- 2. Get all extracurriculars for logged-in user (GET) ---
  Future<List<Extracurricular>> getAllExtracurriculars() async {
    final headers = await _getAuthHeaders(jsonContent: false);

    final response = await http.get(
      Uri.parse('${_baseUrl}all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Extracurricular.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load extracurriculars: ${response.body}');
    }
  }

  Future<Extracurricular> updateExtracurricular(Extracurricular extra) async {
    String? token = await AuthService().getToken();
    print(extra);
    final response = await http.put(
      // Assuming your backend update endpoint is PUT /api/training/{id}

      Uri.parse('${_baseUrl}update/${extra.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(extra.toJson()),
    );

    print('📡 Update Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Assuming the backend returns the updated Training object
      return Extracurricular.fromJson(json.decode(response.body));
    } else {
      print('❌ Update failed: ${response.body}');
      throw Exception('Failed to update training: ${response.statusCode}');
    }
  }

  // --- 3. Delete an extracurricular by ID (DELETE) ---
  Future<void> deleteExtracurricular(int id) async {
    final headers = await _getAuthHeaders(jsonContent: false);

    final response = await http.delete(
      Uri.parse('$_baseUrl$id'),
      headers: headers,
    );

    // 200/204 usually indicates successful deletion
    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else {
      throw Exception('Failed to delete extracurricular: ${response.body}');
    }
  }
}