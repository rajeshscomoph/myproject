import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/config.dart';
// import 'package:myproject/models/school.dart';

class AuthApiService {
  static const String baseUrl = "https://YOUR_API_URL/auth/";

  static Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "password": password}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body)["Access-token"];
    } else if (response.statusCode == 500) {
      throw Exception("Something went wrong");
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      try {
        final body = jsonDecode(response.body);

        final error = body["error"];

        config.logger.d(error);

        // {
        //   "error":"user doesnt have permission"
        // }
        // 400 - bad request
        // 401 - authorised user  ---
        // 402 - access denied
        // 403 - access to resource denied
        // 404 - not found
        // 412 - contact to developer
      } catch (e) {
        config.logger.d(e);
      }
    } else if (response.statusCode >= 300 && response.statusCode < 400) {
      config.logger.d(
        "Status code : ${response.statusCode} body : ${response.body}",
      );
      throw Exception('Something went wrong');
    } else {
      config.logger.d("Status code : ${response.statusCode}");
      throw Exception('Something went wrong');
    }
    return null;
  }




}
