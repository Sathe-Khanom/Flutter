import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../entity/training.dart';

class TrainingService {
  final String baseUrl = 'http://localhost:8085/api/training/'; // Update this

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Assuming you store JWT here
  }

  Future<List<Training>> getTrainings() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${baseUrl}all'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('🔐 Token: $token');
    print('📡 Status: ${response.statusCode}');
    print('📦 Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final body = json.decode(response.body);

        if (body is List) {
          return body.map((json) => Training.fromJson(json)).toList();
        } else {
          print('❗️Unexpected format: expected a JSON array.');
          throw Exception('Invalid response format from API');
        }
      } catch (e) {
        print('❌ JSON decode error: $e');
        throw Exception('Failed to parse training data');
      }
    } else {
      throw Exception('Failed to load trainings: ${response.statusCode}');
    }
  }


  Future<void> addTraining(Training training) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(training.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add training');
    }
  }

  Future<void> deleteTraining(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete training');
    }
  }
}