import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl;
  String? _username;
  String? _nickname;
  String? _secret;
  String? _jwt;

  UserService({required this.baseUrl});

  final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8('ZhangYong:ok_i_xTaskCreate')));

  Future<void> saveUserCredentials(String username, String password) async {
    final encryptedUsername = encrypter.encrypt(username).base64;
    final encryptedPassword = encrypter.encrypt(password).base64;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', encryptedUsername);
    await prefs.setString('password', encryptedPassword);
  }

  Future<Map<String, String>?> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedUsername = prefs.getString('username');
    final encryptedPassword = prefs.getString('password');

    if (encryptedUsername != null && encryptedPassword != null) {
      final username = encrypter.decrypt64(encryptedUsername);
      final password = encrypter.decrypt64(encryptedPassword);
      return {'username': username, 'password': password};
    }

    return null;
  }

  Map<String, String> _addGeneralHeader(Map<String, String> headers) {
    if (_jwt != null) {
      headers['Authorization'] = 'Bearer $_jwt';
    }
    headers['Content-Type'] = 'application/json';
    return headers;
  }

  bool isLoggedIn() {
    return _jwt != null;
  }

  Map<String, String?> getCurrentUser() {
    return {
      'username': _username,
      'nickname': _nickname,
      'secret': _secret,
    };
  }

  Future<String> loginUser(String username, String password) async {
    // print("post to ${Uri.parse('$baseUrl/users/login')} with body: ${jsonEncode({'username': username, 'password': password})}");
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
      _username = username;
      _secret = data['secret'].toString();
      _jwt = data.toString();
      saveUserCredentials(username, password);
      return data.toString();
    } else {
      print(response.body);
      throw Exception('Failed to login');
    }
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

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/pref/$userId'),
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