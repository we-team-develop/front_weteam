import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String _baseUrl = "";

  // Method for GET requests
  Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));
    return response;
  }

  // Method for POST requests
  Future<http.Response> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return response;
  }

  // Method to send idToken to the server for authentication
  Future<http.Response> authenticateWithIdToken(String idToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/your-authentication-endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idToken': idToken}),
    );
    return response;
  }
}
