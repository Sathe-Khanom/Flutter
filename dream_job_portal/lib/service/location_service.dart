import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/location.dart';
// Your Location model file

class LocationService {
  final String apiUrl =  'http://localhost:8085/api/locations/';

  Future<List<Location>> getAllLocations() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<Location> getLocationById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl$id'));

    if (response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load location');
    }
  }

  Future<Location> createLocation(Location location) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(location.toJson()),
    );

    if (response.statusCode == 201) {
      return Location.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create location');
    }
  }

  Future<Location> updateLocation(int id, Location location) async {
    final response = await http.put(
      Uri.parse('$apiUrl$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(location.toJson()),
    );

    if (response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update location');
    }
  }

  Future<void> deleteLocation(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete location');
    }
  }
}
