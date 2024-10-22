import 'dart:convert';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  final String baseUrl;

  final String loginPath = "api/auth/signin";
  final String eventPath = "api/event";
  final String eventSearchPath = "api/event/search";
  Api(this.baseUrl);

  Future<(LoginUser?, String)> loginUser(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/$loginPath');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode != 200) return (null, "");
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data["message"] != "Logged in Successfuly") {
        return (null, "");
      }

      return (LoginUser.fromMap(data['data']), data['token'] as String);
    } catch (e) {
      debugPrint("Error $e");
      return (null, "");
    }
  }

  Future<List<Event>> getEvents({int page = 1}) async {
    try {
      final url = Uri.parse('$baseUrl/$eventPath?page=$page');
      final response = await http.get(url);
      if (response.statusCode != 200) return [];
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['message'] != "Events fetched successfully" || data['data'] == null) {
        return [];
      }
      final eventsMap = data['data']['events'];
      return eventsMap.map<Event>((event) => Event.fromMap(event)).toList();
    } catch (e) {
      return [];
    }
  }
}
