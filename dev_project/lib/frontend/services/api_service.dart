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

  static Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(_url('/profile'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load profile');
  }

  static Future<Map<String, dynamic>> getSettings() async {
    final res = await http.get(_url('/settings'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to load automation settings');
  }

  static Future<Map<String, dynamic>> updateSettings({
    bool? autoReserve,
    bool? liquidityProtection,
    bool? automaticPayments,
    bool? aiOptimization,
  }) async {
    final res = await http.post(
      _url('/settings/update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'auto_reserve': autoReserve,
        'liquidity_protection': liquidityProtection,
        'automatic_payments': automaticPayments,
        'ai_optimization': aiOptimization,
      }..removeWhere((_, value) => value == null)),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to update automation settings');
  }

  static Future<List<dynamic>> getBanks() async {
    final res = await http.get(_url('/banks'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to load banks');
  }

  static Future<Map<String, dynamic>> connectBank(String bankName) async {
    final res = await http.post(
      _url('/connect-bank'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'bank_name': bankName}),
    );

    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to connect bank');
  }

  static Future<List<dynamic>> getActivity() async {
    final res = await http.get(_url('/activity'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as List<dynamic>;
    }
    throw Exception('Failed to load activity');
  }
}
