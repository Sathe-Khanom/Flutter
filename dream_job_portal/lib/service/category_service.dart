import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/category.dart';
import '../entity/location.dart';


class CategoryService {
  final String _baseUrl = 'http://localhost:8085/api/categories/'; // <-- replace with your API base URL

  Future<List<Category>> getAllCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Location>> getLocationsByCategory(int categoryId) async {
    final response = await http.get(Uri.parse('${_baseUrl}by-category $categoryId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<Category> getCategoryById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future<Category> createCategory(Category category) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<Category> updateCategory(int id, Category category) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete category');
    }
  }
}
