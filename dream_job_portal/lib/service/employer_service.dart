import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/employer.dart';



class EmployerService {
  final String _baseUrl = 'http://localhost:8085/api/employer/'; // 🛠️ Update with your API base URL

  // ✅ Register Employer with logo upload (multipart/form-data)
  Future<http.Response> registerEmployer({
    required Map<String, dynamic> user,
    required Map<String, dynamic> employer,
    required File logo,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

    request.fields['user'] = json.encode(user);
    request.fields['employer'] = json.encode(employer);
    request.files.add(await http.MultipartFile.fromPath('logo', logo.path));

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // ✅ Get logged-in employer profile
  Future<Employer> getProfile() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final response = await http.get(
      Uri.parse('${_baseUrl}profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Employer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load employer profile');
    }
  }

  // ✅ Get all employers
  Future<List<Employer>> getAllEmployers() async {
    final response = await http.get(Uri.parse('${_baseUrl}all'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => Employer.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch employers');
    }
  }

  // ✅ Delete employer by ID
  Future<String> deleteEmployer(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$id'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body;
    } else {
      throw Exception('Failed to delete employer');
    }
  }
}
