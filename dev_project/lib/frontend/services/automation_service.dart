import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import '../models/automation_event_model.dart';
import '../models/dashboard_model.dart';

class AutomationService {
  const AutomationService();

  Future<List<AutomationEventModel>> fetchTimeline() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/automation/timeline'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load automation timeline');
    }

    final data = json.decode(response.body) as List<dynamic>;
    return data
        .map((item) => AutomationEventModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<DashboardModel> triggerSalary({
    required double amount,
    double reserveAmount = 400,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/simulate/salary'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': amount,
        'reserve_amount': reserveAmount,
        'source': 'Salary detected',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to simulate salary');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    return DashboardModel.fromJson(body['dashboard'] as Map<String, dynamic>);
  }

  Future<DashboardModel> triggerExpense({required double amount}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/simulate/expense'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': amount,
        'category': 'expense',
        'description': 'Expense detected',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to simulate expense');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    return DashboardModel.fromJson(body['dashboard'] as Map<String, dynamic>);
  }

  Future<DashboardModel> runAutomation() async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/automation/run'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'trigger': 'manual'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to run automation');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    return DashboardModel.fromJson(body['dashboard'] as Map<String, dynamic>);
  }
}
