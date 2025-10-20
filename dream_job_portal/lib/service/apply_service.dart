
import 'dart:convert';

import 'package:code/entity/ApplyDTO.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ApplyService {

  final String baseUrl = 'http://localhost:8085/api/applications';

  Future<http.Response> applyForJob({
    required int jobId,
    required int employerId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'job': {'id': jobId},
      'employer': {'id': employerId},
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Failed to apply for job. Status: ${response.statusCode}');
    }
  }




  Future<List<ApplyDTO>> getApplicationsForJob(int jobId) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await http.get(
      Uri.parse('$baseUrl/applicant/$jobId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ApplyDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load applications');
    }
  }


  


}