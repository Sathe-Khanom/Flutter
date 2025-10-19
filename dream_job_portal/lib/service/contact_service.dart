import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/contact.dart';


class ContactService {
  // environment.ts theke apiUrl niye eshechi
  final String apiUrl = 'http://localhost:8085/api/contact/'; // Update with your actual backend URL

  // JWT/Token dorkar hole, ekhane _getToken() use kora jeto

  Future<List<ContactMessage>> getAllMessages() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Decode the JSON string to a List of Maps
      final List<dynamic> jsonList = json.decode(response.body);

      // Convert List of Maps to List of ContactMessage objects
      return jsonList.map((json) => ContactMessage.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception or a user-friendly message.
      throw Exception('Failed to load contact messages. Status: ${response.statusCode}');
    }
  }

  // sendMessage method-ti ekhane add kora jete pare
  Future<ContactMessage> sendMessage(ContactMessage data) async {
    final response = await http.post(
      Uri.parse(apiUrl), // e.g., 'http://10.0.2.2:8080/api/contact/'
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Backend jodi new create kora message-ti return kore
      return ContactMessage.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send message: ${response.body}');
    }
  }
}