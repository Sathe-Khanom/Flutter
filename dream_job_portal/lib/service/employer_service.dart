import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import '../entity/employer.dart';



class EmployerService {
  final String _baseUrl = 'http://localhost:8085/api/employer/'; // 🛠️ Update with your API base URL

  // Register Employer with logo upload (multipart/form-data) - Mobile
  Future<bool> registerEmployer({
    required Map<String, dynamic> user,
    required Map<String, dynamic> employer,
    required File logo,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

    request.fields['user'] = json.encode(user);
    request.fields['employer'] = json.encode(employer);
    request.files.add(await http.MultipartFile.fromPath('logo', logo.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to register employer: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception during employer registration: $e');
      return false;
    }
  }

  // Register Employer for Flutter Web with bytes upload
  Future<bool> registerEmployerWeb({
    required Map<String, dynamic> user,      // User data (username, email, password, etc.)
    required Map<String, dynamic> employer, // JobSeeker-specific data (skills, CV, etc.)
    File? photoFile,                         // Photo file (used on mobile/desktop platforms)
    Uint8List? photoBytes,                   // Photo bytes (used on web platforms)
  }) async {
    // Create a multipart HTTP request (POST) to your backend API
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(_baseUrl), // Backend endpoint
    );

    // Convert User map into JSON string and add to request fields
    request.fields['user'] = jsonEncode(user);

    // Convert JobSeeker map into JSON string and add to request fields
    request.fields['employer'] = jsonEncode(employer);

    // ---------------------- IMAGE HANDLING ----------------------

    // If photoBytes is available (e.g., from web image picker)
    if (photoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'logo',                // backend expects field name 'photo'
          photoBytes,             // Uint8List is valid here
          filename: 'profile.png' // arbitrary filename for backend
      ));
    }

    // If photoFile is provided (mobile/desktop), attach it
    else if (photoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'logo',                // backend expects field name 'photo'
        photoFile.path,         // file path from File object
      ));
    }

    // ---------------------- SEND REQUEST ----------------------

    // Send the request to backend
    var response = await request.send();

    // Return true if response code is 200 (success)
    return response.statusCode == 200;
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
