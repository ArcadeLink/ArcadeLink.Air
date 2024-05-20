import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;
  String? _username;
  String? _secret;
  String? _jwt;

  UserService({required this.baseUrl});

  Map<String, String> _addAuthorizationHeader(Map<String, String> headers) {
    if (_jwt != null) {
      headers['Authorization'] = 'Bearer $_jwt';
    }
    return headers;
  }

  Map<String, String?> getCurrentUser() {
    return {
      'username': _username,
      'secret': _secret,
    };
  }

  Future<String> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _username = username;
      _secret = data['secret'].toString();
      _jwt = data.toString();
      return data.toString();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String> registerUser(String username, String password, String nickname) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      body: jsonEncode({
        'username': username,
        'password': password,
        'nickname': nickname,
      }),
    );

    if (response.statusCode == 200) {
      return 'User registered successfully';
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<String> registerUserTemp() async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register/temp'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['userId'];
    } else {
      throw Exception('Failed to register temporary user');
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/pref/$userId'),
      headers: _addAuthorizationHeader({}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user info');
    }
  }

  Future<String> refreshSecret(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/secret/$userId'),
      headers: _addAuthorizationHeader({}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data.toString();
    } else {
      throw Exception('Failed to refresh secret');
    }
  }

  Future<bool> changeUsername(String userId, String newUsername) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/nickname'),
      body: jsonEncode({
        'userId': userId,
        'newUsername': newUsername,
      }),
      headers: _addAuthorizationHeader({}),
    );

    return response.statusCode == 200;
  }

  Future<bool> changePassword(String userId, String oldPassword, String newPassword) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/password'),
      body: jsonEncode({
        'userId': userId,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
      headers: _addAuthorizationHeader({}),
    );

    return response.statusCode == 200;
  }
}