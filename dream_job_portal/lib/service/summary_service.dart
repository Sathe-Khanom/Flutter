import 'dart:convert';
import 'package:code/service/authservice.dart';
import 'package:http/http.dart' as http;

class SummaryService {
  final String baseUrl = "http://localhost:8085";

  Future<Map<String, dynamic>?> getJobSeekerSummary() async {
    String? token = await AuthService().getToken();

    if (token == null) {
      print('No token found, please login first.');
      return null;
    }

    final url = Uri.parse('$baseUrl/api/summery/all');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response: $data');

      // ✅ Return first object from the list
      if (data is List && data.isNotEmpty) {
        return data[0];
      } else {
        print('Unexpected response format: $data');
        return null;
      }
    } else {
      print('Failed to load summary: ${response.statusCode} - ${response.body}');
      return null;
    }
  }


  Future<Map<String, dynamic>?> getSummaryById(int id) async {
    String? token = await AuthService().getToken();

    if (token == null) {
      print('No token found, please login first.');
      return null;
    }

    final url = Uri.parse('$baseUrl/api/summery/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Response: $data');
      return data;
    } else {
      print('Failed to load summary: ${response.statusCode} - ${response.body}');
      return null;
    }
  }


  Future<bool> updateSummary(int id, Map<String, dynamic> summaryData) async {
    String? token = await AuthService().getToken();

    if (token == null) {
      print('No token found, please login first.');
      return false;
    }

    final url = Uri.parse('$baseUrl/api/summery/update/$id');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(summaryData),
    );

    if (response.statusCode == 200) {
      print('Summary updated successfully');
      return true;
    } else {
      print('Failed to update summary: ${response.statusCode} - ${response.body}');
      return false;
    }
  }


}
