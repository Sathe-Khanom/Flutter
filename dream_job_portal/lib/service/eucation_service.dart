import 'dart:convert';

import 'package:code/service/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:code/entity/education.dart';


class EducationService {
  final String baseUrl = 'http://localhost:8085/api/education/all'; // replace with your actual API URL

  Future<List<Education>> fetchEducations() async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // if you are using JWT auth
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Education.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load educations');
    }
  }




  // Update an education
  Future<Education> updateEducation(Education education) async {
    // Get JWT token from your AuthService
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('http://localhost:8085/api/education/update/${education.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // <-- add token here
      },
      body: jsonEncode(education.toJson()),
    );

    if (response.statusCode == 200) {
      return Education.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update education: ${response.body}');
    }
  }



}