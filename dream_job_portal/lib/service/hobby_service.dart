import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/hobby.dart';
import 'authservice.dart';


class HobbyService {
  final String _baseUrl = 'http://localhost:8085/api/hobby/';



  // POST: Adds a new hobby and returns the added Hobby object (Future<Hobby>).
  // The token is passed explicitly, replacing the platform/localStorage check.
  Future<Hobby> addHobby(Hobby data, String? authToken) async {

    String? token = await AuthService().getToken();


    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // if you are using JWT auth
        },
          body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Decode the JSON response body
        return Hobby.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add hobby: ${response.statusCode}');
      }
    } catch (e) {
      // Catch network or decoding errors
      throw Exception('An error occurred during addHobby: $e');
    }
  }

  // GET: Fetches all hobbies and returns a list (Future<List<Hobby>>).
  Future<List<Hobby>> getAllHobbies(String? authToken) async {

    String? token = await AuthService().getToken();

    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // if you are using JWT auth
        },

      );

      if (response.statusCode == 200) {
        // Parse the response body as a list of dynamic maps
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Map the list of maps to a list of Hobby objects
        return jsonList.map((json) => Hobby.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hobbies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during getAllHobbies: $e');
    }
  }

  Future<Hobby> updateHobby(Hobby hobby) async {
    // Get JWT token from your AuthService
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('http://localhost:8085/api/hobby/update/${hobby.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- add token here
      },
      body: jsonEncode(hobby.toJson()),
    );

    if (response.statusCode == 200) {
      return Hobby.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update Hobby: ${response.body}');
    }
  }


  // DELETE: Removes a hobby by ID (Future<void>).
  Future<void> deleteHobby(int id) async {
    final url = Uri.parse('$_baseUrl$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        // Handle non-200 responses (e.g., 404 Not Found, 401 Unauthorized)
        throw Exception('Failed to delete hobby: ${response.statusCode}');
      }
      // If 200/204, return successfully (void)
    } catch (e) {
      throw Exception('An error occurred during deleteHobby: $e');
    }
  }
}
