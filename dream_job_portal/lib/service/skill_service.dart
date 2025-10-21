import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/skill.dart';
import 'authservice.dart';



class SkillService {

  final String _baseUrl = 'http://localhost:8085/api/skill/';

  /// POST: Adds a new skill.
  /// Requires authentication token.
  Future<Skill> addSkill(Skill data) async {
    String? token = await AuthService().getToken();

    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}add'),
        headers: {
          'Content-Type': 'application/json',
          // Add Authorization header only if the token is available
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decode the JSON response body
        return Skill.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add skill. Status: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during addSkill: $e');
    }
  }


  Future<List<Skill>> getAllSkills() async {
    String? token = await AuthService().getToken();

    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}all'),
        headers: {
          'Content-Type': 'application/json',
          // Add Authorization header only if the token is available
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body as a list of dynamic maps
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Map the list of maps to a list of Skill objects
        return jsonList.map((json) => Skill.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load skills. Status: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('An error occurred during getAllSkills: $e');
    }
  }

  Future<Skill> updateSkill(Skill skill) async {
    // Get JWT token from your AuthService
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('http://localhost:8085/api/skill/update/${skill.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- add token here
      },
      body: jsonEncode(skill.toJson()),
    );

    if (response.statusCode == 200) {
      return Skill.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update language: ${response.body}');
    }
  }


  Future<void> deleteSkill(int id) async {
    final url = Uri.parse('$_baseUrl$id');
    String? token = await AuthService().getToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          // Authentication token is usually required for deletion
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete skill. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during deleteSkill: $e');
    }
  }
}
