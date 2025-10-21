import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/language.dart';
import 'authservice.dart';


class LanguageService {
  // Use a hardcoded URL similar to your HobbyService example
  final String _baseUrl = 'http://localhost:8085/api/language/';


  Future<Language> addLanguage(Language data) async {
    // 1. Get the authentication token
    String? token = await AuthService().getToken();

    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}add'),
        headers: {
          'Content-Type': 'application/json',
          // 2. Add Authorization header only if the token is available
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decode the JSON response body
        return Language.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add language. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during addLanguage: $e');
    }
  }

  // GET: Fetches all languages and returns a list (Future<List<Language>>).
  Future<List<Language>> getAllLanguages() async {
    // 1. Get the authentication token
    String? token = await AuthService().getToken();

    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}all'),
        headers: {
          'Content-Type': 'application/json',
          // 2. Add Authorization header only if the token is available
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body as a list of dynamic maps
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Map the list of maps to a list of Language objects
        return jsonList.map((json) => Language.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load languages. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during getAllLanguages: $e');
    }
  }

  Future<Language> updateLanguage(Language language) async {
    // Get JWT token from your AuthService
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('http://localhost:8085/api/language/update/${language.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- add token here
      },
      body: jsonEncode(language.toJson()),
    );

    if (response.statusCode == 200) {
      return Language.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update language: ${response.body}');
    }
  }


  Future<void> deleteLanguage(int id) async {
    final url = Uri.parse('$_baseUrl$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete language. Status: ${response.statusCode}');
      }
      // If 200/204, return successfully (void)
    } catch (e) {
      throw Exception('An error occurred during deleteLanguage: $e');
    }
  }
}
