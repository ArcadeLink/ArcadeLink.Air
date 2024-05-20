import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String baseUrl;
  String? _username;
  String? _nickname;
  String? _secret;
  String? _jwt;

  UserService({required this.baseUrl});

  ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  Future<void> saveJwt(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', jwt);
    print("jwt saved: $jwt");
  }

  Future<String?> getJwt() async {
    print("reading jwt...");
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  Future<bool> isJwtValid() async {
    final jwt = await getJwt();
    if (jwt != null) {
      try {
        final parts = jwt.split('.');
        if (parts.length != 3) {
          return false;
        }
        final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
        final payloadMap = jsonDecode(payload);
        if (DateTime.fromMillisecondsSinceEpoch(payloadMap['exp'] * 1000).isAfter(DateTime.now())) {
          _jwt = jwt;
          print("jwt is valid, saving... $_jwt ");
          return true;
        }
      } catch (e) {
        print("jwt expired or invalid: $e");
        return false;
      }
    }
    print("jwt not found or expired");
    return false;
  }

  Future<String> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _jwt = data["data"].toString();
      _username = username;
      print("login successful, saving jwt... $_jwt");
      saveJwt(_jwt!);
      isLoggedIn.value = true;
      return data.toString();
    } else {
      print(response.body);
      throw Exception('Failed to login');
    }
  }

  Map<String, String> _addGeneralHeader(Map<String, String> headers) {
    if (_jwt != null) {
      headers['Authorization'] = 'Bearer $_jwt';
    }
    headers['Content-Type'] = 'application/json';
    return headers;
  }

  Map<String, String?> getCurrentUser() {
    return {
      'username': _username,
      'nickname': _nickname,
      'secret': _secret,
    };
  }

  Future<String> registerUser(String username, String password, String nickname) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
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

  Future<Map<String, dynamic>> getUserInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/pref/'),
      headers: _addGeneralHeader({}),
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
      headers: _addGeneralHeader({}),
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
      headers: _addGeneralHeader({}),
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
      headers: _addGeneralHeader({}),
    );

    return response.statusCode == 200;
  }
}