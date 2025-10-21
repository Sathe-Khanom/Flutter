import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/reference.dart';
import 'authservice.dart';


class RefferenceService {
  // Use a hardcoded URL similar to your LanguageService example
  final String _baseUrl = 'http://localhost:8085/api/refference/';

  /// POST: Adds a new refference.
  Future<Reference> addReference(Reference data) async {
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
        return Reference.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add reference. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during addReference: $e');
    }
  }

  /// GET: Fetches all refferences.
  Future<List<Reference>> getAllReferences() async {
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

        // Map the list of maps to a list of Refference objects
        return jsonList.map((json) => Reference.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load references. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during getAllReferences: $e');
    }
  }


  Future<Reference> updateReference(Reference refference) async {
    // Get JWT token from your AuthService
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('http://localhost:8085/api/refference/update/${refference.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- add token here
      },
      body: jsonEncode(refference.toJson()),
    );

    if (response.statusCode == 200) {
      return Reference.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update language: ${response.body}');
    }
  }


  /// DELETE: Removes a refference by ID.
  Future<void> deleteReference(int id) async {
    final url = Uri.parse('$_baseUrl$id');

    try {
      final response = await http.delete(
        url,
        // Authentication token is usually required for deletion
        headers: {
          if (await AuthService().getToken() != null)
            'Authorization': 'Bearer ${await AuthService().getToken()}',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete reference. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during deleteReference: $e');
    }
  }
}
