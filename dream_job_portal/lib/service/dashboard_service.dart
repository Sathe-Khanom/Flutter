import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final String _baseUrl = 'http://localhost:8085/api/admin/'; // ✅ Update with real API URL

  Future<Map<String, dynamic>> getDashboardCounts() async {
    final response = await http.get(Uri.parse('${_baseUrl}counts'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load dashboard counts');
    }
  }
}
