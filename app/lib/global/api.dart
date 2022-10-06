import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Api {
  static const kEndpoint = 'http://localhost:8080';

  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    http.Response response = await http.post(Uri.parse('$kEndpoint/login'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({"username": username, 'password': password}));
    print(response.statusCode);
    return response.statusCode == 200;
  }
}