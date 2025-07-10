import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/models/school.dart';

class SchoolApiService {
  static const String baseUrl = "https://YOUR_API_URL/schools";

  Future<List<School>> getSchools() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => School.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load schools');
    }
  }

  Future<School> createSchool(School school) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );
    if (response.statusCode == 201) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create school');
    }
  }

  Future<School> updateSchool(int schoolCode, School school) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$schoolCode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );
    if (response.statusCode == 200) {
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update school');
    }
  }

  Future<void> deleteSchool(int schoolCode) async {
    final response = await http.delete(Uri.parse('$baseUrl/$schoolCode'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete school');
    }
  }
}
