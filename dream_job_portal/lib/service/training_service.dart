import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/training.dart';
import 'authservice.dart';

class TrainingService {
  final String baseUrl = 'http://localhost:8085/api/training/';

  // Update this
  Future<List<Training>> fetchTraining() async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse(baseUrl+"all"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // if you are using JWT auth
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Training.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load training');
    }
  }




  Future<void> addTraining(Training training) async {
    String? token = await AuthService().getToken();

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

  Future<Training> updateTraining(Training training) async {
    String? token = await AuthService().getToken();
    print(training);
    final response = await http.put(
      // Assuming your backend update endpoint is PUT /api/training/{id}

      Uri.parse('${baseUrl}update/${training.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(training.toJson()),
    );

    print('📡 Update Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Assuming the backend returns the updated Training object
      return Training.fromJson(json.decode(response.body));
    } else {
      print('❌ Update failed: ${response.body}');
      throw Exception('Failed to update training: ${response.statusCode}');
    }
  }

  Future<void> deleteTraining(int id) async {
    String? token = await AuthService().getToken();

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