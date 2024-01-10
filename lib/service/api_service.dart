import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends GetxService {
  final String _baseUrl = "http://15.164.221.170:9090/api"; // baseUrl 주소/api

  // GET requests 메소드 예제
  Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));
    return response;
  }

  // POST requests 메소드 예제
  Future<http.Response> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return response;
  }

  // send idToken to the server for authentication 메소드 예제
  Future<http.Response> authenticateWithIdToken(String idToken) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/your-authentication-endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idToken': idToken}),
    );
    return response;
  }
}
