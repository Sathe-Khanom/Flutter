import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../entity/job.dart';



class JobService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://localhost:8085/api/jobs/';

  // Get auth headers with bearer token
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'authToken');
    if (token != null) {
      return {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    }
    return {
      'Content-Type': 'application/json',
    };
  }

  // Create job
  Future<Job> createJob(Map<String, dynamic> data) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create job: ${response.body}');
    }
  }

  // Get all jobs by employer ID
  Future<List<Job>> getJobsByEmployerId(int employerId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl+employer/$employerId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employer jobs');
    }
  }

  // Delete a job
  Future<void> deleteJob(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$id'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete job');
    }
  }

  // Update a job
  Future<Job> updateJob(int id, Map<String, dynamic> jobData) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: jsonEncode(jobData),
    );

    if (response.statusCode == 200) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update job');
    }
  }

  // Get job by ID
  Future<Job> getJobById(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get job');
    }
  }

  // Get all jobs
  Future<List<Job>> getAllJobs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  // Search jobs by category and/or location
  Future<List<Job>> searchJobs({int? categoryId, int? locationId}) async {
    final queryParams = <String, String>{};
    if (categoryId != null) queryParams['categoryId'] = categoryId.toString();
    if (locationId != null) queryParams['locationId'] = locationId.toString();

    final uri = Uri.parse('${baseUrl}search').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Job search failed');
    }
  }

  // Get current employer's jobs
  Future<List<Job>> getMyJobs() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('${baseUrl}my-jobs'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch your jobs');
    }
  }

  // Get jobs by company name
  Future<List<Job>> getJobsByCompany(String companyName) async {
    final uri = Uri.parse('${baseUrl}company?companyName=$companyName');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch jobs by company');
    }
  }
}
