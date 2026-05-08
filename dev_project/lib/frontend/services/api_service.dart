import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiService {
  static Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  static Future<Map<String, dynamic>> getDashboard() async {
    final res = await http.get(_url('/dashboard'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load dashboard');
  }

  static Future<List<dynamic>> getTransactions() async {
    final res = await http.get(_url('/transactions'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to load transactions');
  }

  static Future<List<dynamic>> getAutomationTimeline() async {
    final res = await http.get(_url('/automation/timeline'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to load automation timeline');
  }
}
